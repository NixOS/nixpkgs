{
  lib,
  pkgs,
  ...
}:
{
  name = "reaction-core-plugins";

  nodes.server = args: {
    services.reaction = {
      enable = true;
      stopForFirewall = false;
      runAsRoot = false;
      settings = import ./settings.nix args;
      /*
        # NOTE: When runAsRoot is true, disable run0
        settings = {
          # In the qemu vm `run0 ls` as root prints nothing, so we can't use it
          # see https://reaction.ppom.me/reference.html#systemd
          plugins.ipset.systemd = false;
          plugins.virtual.systemd = false;
        };
      */
    };
    /*
      NOTE:
        - if reaction is run as non-root, the plugins need these capabilities, remove these if runAsRoot is true
        - CAP_DAC_READ_SEARCH is for journalctl for accessing ssh logs
        - useful tools: capable (from package bcc), captree, getpcaps (from libpcap)
    */
    systemd.services.reaction.serviceConfig = {
      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_DAC_READ_SEARCH"
      ];
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
        "CAP_DAC_READ_SEARCH"
      ];
    };
    services.openssh.enable = true;

    users.users.nixos.isNormalUser = true; # neeeded to establish a ssh connection, by default root login is succeeding without any password
  };

  nodes.client = _: {
    environment.systemPackages = [
      pkgs.sshpass
      pkgs.libressl.nc
    ];
  };

  testScript =
    { nodes, ... }: # py
    ''
      start_all()

      # Wait for everything to be ready.
      server.wait_for_unit("multi-user.target")
      server.wait_for_unit("reaction")
      server.wait_for_unit("sshd")

      client_addr = "${(lib.head nodes.client.networking.interfaces.eth1.ipv4.addresses).address}"
      server_addr = "${(lib.head nodes.server.networking.interfaces.eth1.ipv4.addresses).address}"

      # Verify there is not ban and the port is reachable from the client.
      server.succeed(f"reaction show | grep -q {client_addr} || test $? -eq 1")
      client.succeed(f"nc -w3 -z {server_addr} 22")

      # Cause authentication failure log entries.
      for _ in range(2):
        client.fail(f"""
          sshpass -p 'wrongpassword' \
            ssh -o StrictHostKeyChecking=no \
              -o User=nixos \
              -o ServerAliveInterval=1 \
              -o ServerAliveCountMax=2 \
              {server_addr}
        """)

      # Verify there is a ban and the port is unreachable from the client.
      server.sleep(2)
      output = server.succeed("reaction show")
      print(output)
      assert client_addr in output, f"client did not get banned, {client_addr}"

      client.fail(f"nc -w3 -z {server_addr} 22")

      # Check that unbanning works
      output = server.succeed("reaction flush")
      print(output)

      client.succeed(f"nc -w3 -z {server_addr} 22")
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.reaction.driverInteractive -L
  # - run_tests()
  # ssh -o User=root vsock%3 (can also do vsock/3, but % works with scp etc.)
  # ssh -o User=root vsock%4
  interactive.sshBackdoor.enable = true;

  interactive.nodes.server =
    { config, ... }:
    {
      # not needed, only for manual interactive debugging
      virtualisation.memorySize = 4096;
      virtualisation.graphics = false;
      environment.systemPackages = with pkgs; [
        btop
        sysz
        sshpass
        libressl.nc
      ];
    };

  meta.maintainers =
    with lib.maintainers;
    [
      ppom
    ]
    ++ lib.teams.ngi.members;
}
