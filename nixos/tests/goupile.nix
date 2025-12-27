{ lib, pkgs, ... }:
{
  name = "goupile";

  nodes.machine =
    { lib, pkgs, ... }:
    {
      services.goupile.enable = true;
      services.goupile.enableSandbox = false; # TODO fails in vm if enabled
      services.goupile.settings.HTTP.Port = 8889;
      #environment.variables.SYSTEMD_SECCOMP = "0";
    };

  testScript =
    { nodes, ... }:
    let
      port = builtins.toString nodes.machine.services.goupile.settings.HTTP.Port;
    in
    # py
    ''
      start_all()

      machine.wait_for_unit("goupile.service")
      machine.wait_for_open_port(${port})

      machine.succeed("curl -q http://localhost:${port}")
    '';

  # Debug interactively with:
  # - nix run .#nixosTests.goupile.driverInteractive -L
  # - run_tests()
  # ssh -o User=root vsock%3 (can also do vsock/3, but % works with scp etc.)
  interactive.sshBackdoor.enable = true;

  interactive.nodes.machine =
    { config, ... }:
    let
      port = config.services.goupile.settings.HTTP.Port;
    in
    {
      environment.systemPackages = with pkgs; [
        btop
        sysz
      ];

      virtualisation.forwardPorts = map (port: {
        from = "host";
        host.port = port;
        guest.port = port;
      }) [ port ];

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ port ];
    };

  meta.maintainers = with lib.maintainers; [ phanirithvij ] ++ lib.teams.ngi.members;
}
