{ config, lib, moduleType, hostPkgs, ... }:
let
  inherit (lib) mkOption types mdDoc;
in
{
  options = {
    interactive = mkOption {
      description = mdDoc ''
        Tests [can be run interactively](#sec-running-nixos-tests-interactively).

        When they are, the configuration will include anything set in this submodule.

        You can set any top-level test option here.
      '';
      type = moduleType;
      visible = "shallow";
    };
  };

  config = {
    interactive.qemu.package = hostPkgs.qemu;
    interactive.extraDriverArgs = [ "--interactive" ];
    passthru.driverInteractive = config.interactive.driver;
  };
}
