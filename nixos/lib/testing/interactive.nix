{
  config,
  lib,
  moduleType,
  hostPkgs,
  ...
}:
let
  inherit (lib) mkOption;
in
{
  options = {
    interactive = mkOption {
      description = ''
        Tests [can be run interactively](#sec-running-nixos-tests-interactively)
        using the program in the test derivation's `.driverInteractive` attribute.

        When they are, the configuration will include anything set in this submodule.

        You can set any top-level test option here.

        Example test module:

        ```nix
        { config, lib, ... }: {

          nodes.rabbitmq = {
            services.rabbitmq.enable = true;
          };

          # When running interactively ...
          interactive.nodes.rabbitmq = {
            # ... enable the web ui.
            services.rabbitmq.managementPlugin.enable = true;
          };
        }
        ```

        For details, see the section about [running tests interactively](#sec-running-nixos-tests-interactively).
      '';
      type = moduleType;
      visible = "shallow";
    };
  };

  config = {
    interactive.qemu.package = hostPkgs.qemu;
    interactive.extraDriverArgs = [ "--interactive" ];
    interactive.driverConfiguration.containers = lib.mapAttrs (_: machine: {
      vnc = lib.mkIf machine.services.xserver.enable {
        x11vnc = lib.getExe hostPkgs.x11vnc;
        tigervnc = lib.getExe' hostPkgs.tigervnc "vncviewer";
      };
    }) config.containers;
    passthru.driverInteractive = config.interactive.driver;
  };
}
