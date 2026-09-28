{
  config,
  lib,
  moduleType,
  hostPkgs,
  ...
}:
let
  inherit (lib) mkOption;
  x11Containers = lib.filterAttrs (
    _: machine: lib.any (target: target.backend == "x11") machine.testing.displayTargets
  ) config.containers;
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
    interactive.driverConfiguration = lib.mkIf hostPkgs.stdenv.hostPlatform.isLinux {
      containers = lib.mapAttrs (_: _: {
        display_exporters.x11 = {
          kind = "x11-vnc";
          server = lib.getExe hostPkgs.x11vnc;
          relay = lib.getExe hostPkgs.socat;
        };
      }) x11Containers;
      display_viewers = lib.mkIf (x11Containers != { }) {
        vnc = {
          kind = "vnc";
          executable = lib.getExe' hostPkgs.virt-viewer "remote-viewer";
        };
      };
    };
    passthru.driverInteractive = config.interactive.driver;
  };
}
