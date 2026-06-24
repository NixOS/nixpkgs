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
        services.icosa-gallery.host = "0.0.0.0";

        # forward ports from VM to host
        virtualisation.forwardPorts =
          let
            inherit (config.services.icosa-gallery) port;
          in
          [
            {
              from = "host";
              host = { inherit port; };
              guest = { inherit port; };
            }
          ];

        # forwarded ports need to be accessible
        networking.firewall.enable = false;
      };
  };
}
