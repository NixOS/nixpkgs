{
  lib,
  pkgs,
  ...
}:
{
  name = "reaction";

  nodes.server = _: {
    services.reaction = {
      enable = true;
      stopForFirewall = false;
      settingsFiles = [
        "${pkgs.reaction}/share/examples/example.jsonnet"
        # "${pkgs.reaction}/share/examples/example.yml" # can't specify both because conflicts
      ];
      runAsRoot = false;
    };
    services.openssh.enable = true;

    # required to access journal of sshd.service as runAsRoot = false
    users.users.reaction.extraGroups = [ "systemd-journal" ];
    # required for allowing reaction to modifiy firewall rules
    systemd.services.reaction.serviceConfig.AmbientCapabilities = [ "CAP_NET_ADMIN" ];

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
      client.wait_for_unit("multi-user.target")

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
      phanirithvij
    ]
    ++ lib.teams.ngi.members;
}
