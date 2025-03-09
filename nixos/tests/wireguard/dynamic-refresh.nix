import ../make-test-python.nix (
  {
    pkgs,
    lib,
    kernelPackages ? null,
    useNetworkd ? false,
    ...
  }:
  let
    wg-snakeoil-keys = import ./snakeoil-keys.nix;
  in
  {
    name = "wireguard-dynamic-refresh";
    meta = with lib.maintainers; {
      maintainers = [ majiir ];
    };

    nodes = {
      server = {
        virtualisation.vlans = [
          1
          2
        ];
        boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
        networking.firewall.allowedUDPPorts = [ 23542 ];
        networking.useDHCP = false;
        networking.wireguard.useNetworkd = useNetworkd;
        networking.wireguard.interfaces.wg0 = {
          ips = [ "10.23.42.1/32" ];
          listenPort = 23542;

          # !!! Don't do this with real keys. The /nix store is world-readable!
          privateKeyFile = toString (pkgs.writeText "privateKey" wg-snakeoil-keys.peer0.privateKey);

          peers = lib.singleton {
            allowedIPs = [ "10.23.42.2/32" ];

            inherit (wg-snakeoil-keys.peer1) publicKey;
          };
        };
      };

      client =
        { nodes, ... }:
        {
          virtualisation.vlans = [
            1
            2
          ];
          boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
          networking.useDHCP = false;
          networking.wireguard.useNetworkd = useNetworkd;
          networking.wireguard.interfaces.wg0 = {
            ips = [ "10.23.42.2/32" ];

            # !!! Don't do this with real keys. The /nix store is world-readable!
            privateKeyFile = toString (pkgs.writeText "privateKey" wg-snakeoil-keys.peer1.privateKey);

            dynamicEndpointRefreshSeconds = 2;

            peers = lib.singleton {
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
              endpoint = "server:23542";

              inherit (wg-snakeoil-keys.peer0) publicKey;
            };
          };

          specialisation.update-hosts.configuration = {
            networking.extraHosts =
              let
                testCfg = nodes.server.virtualisation.test;
              in
              lib.mkForce "192.168.2.${toString testCfg.nodeNumber} ${testCfg.nodeName}";
          };
        };
    };

    testScript =
      { nodes, ... }:
      ''
        start_all()

        server.wait_for_unit("network-online.target")
        client.wait_for_unit("network-online.target")

        client.succeed("ping -n -w 1 -c 1 10.23.42.1")

        client.succeed("ip link set down eth1")

        client.fail("ping -n -w 1 -c 1 10.23.42.1")

        with client.nested("update hosts file"):
          client.succeed("${nodes.client.system.build.toplevel}/specialisation/update-hosts/bin/switch-to-configuration test")

        client.succeed("sleep 5 && ping -n -w 1 -c 1 10.23.42.1")
      '';
  }
)
