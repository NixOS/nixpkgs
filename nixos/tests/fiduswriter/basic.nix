{
  lib,
  pkgs,
  ...
}:

{
  name = "FidusWriter basic";

  nodes = {
    machine =
      { ... }:
      {
        imports = [
          ./config.nix
        ];
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      machine.succeed()
    '';

  # Debug interactively with:
  # - nix run -f . nixosTests.fiduswriter.basic.driverInteractive
  # - run_tests()
  interactive.sshBackdoor.enable = true;
  interactive.nodes = {
    machine =
      { config, ... }:
      {
        # forward ports from VM to host
        virtualisation.forwardPorts =
          map
            (port: {
              from = "host";
              host.port = port;
              guest.port = port;
            })
            [
              8000
            ];

        # forwarded ports need to be accessible
        networking.firewall.enable = false;
      };
  };
}
