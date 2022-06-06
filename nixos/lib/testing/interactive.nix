{ config, lib, moduleType, hostPkgs, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    interactive = mkOption {
      description = "All the same options, but configured for interactive use.";
      type = moduleType;
    };
  };

  config = {
    interactive.qemu.package = hostPkgs.qemu;
    interactive.extraDriverArgs = [ "--interactive" ];
    passthru.driverInteractive = config.interactive.driver;
  };
}
