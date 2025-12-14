{ lib, pkgs, ... }:
{
  name = "goupile";

  nodes.machine =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      services.goupile = {
        enable = true;
        enableSandbox = true;
        settings.HTTP.Port = 8889;
      };
      #systemd.services.goupile.environment.DEFAULT_SECCOMP_ACTION = "Log"; # Block|Log|Kill
      networking = {
        firewall.allowedTCPPorts = [ config.services.nginx.defaultHTTPListenPort ];
        hostName = "goupile";
        domain = "local";
      };
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
      machine.succeed("curl -q http://goupile.local")
      machine.succeed("curl -q http://localhost")
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
      virtualisation.forwardPorts = map (port: {
        from = "host";
        host.port = port;
        guest.port = port;
      }) [ port ];

      # forwarded ports need to be accessible
      networking.firewall.allowedTCPPorts = [ port ];

      virtualisation.graphics = false;
    };

  meta.maintainers = lib.teams.ngi.members;
}
