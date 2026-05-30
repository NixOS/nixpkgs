{ pkgs, lib, ... }:

let
  # Test by creating a "group" of interfaces: a VRF, plus a dummy interface under it, to which we'll assign an IPv6 ULA address
  # This must be done for both configs under /etc ("static") and configs under /run ("dynamic"). So each test group gets an address
  test-groups = {
    "static" = "fd00::feed:cafe/32";
    "dynamic" = "fd00::dead:beef/32";
  };

  # Generate link information, interface getter commands, and configuration files, to be used on all test VMs
  # The variable respects the globs:
  # - fixtures.{static,dynamic}.links.{vrf,dummy}.{name,getter-cmd,address} (NB: address is unavailable in 'vrf')
  # - fixtures.{static,dynamic}.cfgs.{networkd,NetworkManager}.{filename,src}
  fixtures = lib.mapAttrs (
    group: address:
    let
      vrf-name = "np${group}";
    in
    {
      links.vrf.name = "${vrf-name}";
      links.vrf.getter-cmd = "ip -o link show dev ${vrf-name} type vrf";
      links.dummy.name = "${vrf-name}-lo";
      links.dummy.getter-cmd = "ip -o link show dev ${vrf-name}-lo type dummy master ${vrf-name}";
      links.dummy.address = address;
      cfgs = lib.genAttrs [ "networkd" "NetworkManager" ] (renderer: get-config-file group renderer);
    }
  ) test-groups;

  # Utility to generate netplan configuration objects
  get-config-file = (
    group: renderer:
    let
      links = fixtures.${group}.links;
      content = ''
        ---
        network:
          version: 2
          renderer: ${renderer}
          dummy-devices:
            ${links.dummy.name}:
              addresses: ["${links.dummy.address}"]
          vrfs:
            ${links.vrf.name}:
              table: 130
              interfaces: [${links.dummy.name}]
      '';
    in
    {
      filename = "10-test-${group}-${renderer}.yaml";
      src = pkgs.writeText "netplan-test-${group}-${renderer}" content;
    }
  );

in
{
  name = "netplan";
  meta.maintainers = with lib.maintainers; [
    mkg20001
  ];

  nodes = {
    networkd =
      { config, ... }:
      {
        networking.useNetworkd = true;
        systemd.network.enable = true;
        networking.useDHCP = false;
        networking.netplan.install = true;
        networking.netplan.enable = true;
        networking.netplan.configFiles = {
          ${fixtures.static.cfgs.networkd.filename} = builtins.readFile fixtures.static.cfgs.networkd.src;
        };
        virtualisation.cores = 4;
      };
    networkmanager =
      { config, ... }:
      {
        networking.networkmanager.enable = true;
        networking.netplan.install = true;
        networking.netplan.enable = true;
        networking.netplan.configFiles = {
          ${fixtures.static.cfgs.NetworkManager.filename} =
            builtins.readFile fixtures.static.cfgs.NetworkManager.src;
        };
        virtualisation.cores = 4;
      };
  };

  testScript = ''
    import json

    fixtures = json.loads('${builtins.toJSON fixtures}')
    start_all()

    # Test both networkd and networkmanager backends
    for machine in [networkd, networkmanager]:

      # Prepare variables for testing
      renderer = "networkd" if machine is networkd else "NetworkManager"
      configfiles = dict()
      links = dict()
      for group in ['static', 'dynamic']:
        links[group] = list(fixtures[group]['links'].items())
        configfiles[group] = fixtures[group]['cfgs'][renderer]

      # Wait for tests to be runnable
      machine.wait_for_unit("network.target")

      # Basic tests
      with subtest("Check that netplan package has been installed and is able to run"):
        machine.succeed("which netplan")
        machine.succeed("netplan --help")

      # Module tests
      with subtest("Check that the nixos module wrote the configuration file"):
        machine.succeed(f"ls /etc/netplan/{configfiles['static']['filename']}")

      # Run the interface checks twice: once before applying the dynamic config, and once after
      for dynamic_config in [False, True]:

        # If testing the synamic, write out the fixture YAML file, and apply it
        if dynamic_config:
          with subtest("Run netplan apply to configure dynamic interfaces"):
            destination_filename = f"/run/netplan/{configfiles['dynamic']['filename']}"
            machine.copy_from_host_via_shell(configfiles['dynamic']['src'], destination_filename)
            machine.execute(f"chown root:root {destination_filename}")
            machine.execute(f"chmod 0700 {destination_filename}")
            machine.succeed("netplan apply")

        # Check that the interfaces exist and are of the right type
        # Commands below rely on '-o pipefail' being set in the shell
        links_to_test = links['static'] + (links['dynamic'] if dynamic_config else [])
        with subtest(f"Check that netplan correctly configured the network interfaces ({'/run populated' if dynamic_config else 'right after boot'})"):
          for link_type, link in links_to_test:
            link_name = link['name']
            machine.wait_until_succeeds(f"{link['getter-cmd']} | grep {link_name}")
            # For the dummy interface, check the IP address as well
            if link_type == 'dummy':
              machine.wait_until_succeeds(f"ip -o addr show {link_name} to {link['address']} | grep {link_name}")
  '';
}
