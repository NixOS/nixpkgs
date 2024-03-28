{ config, lib, pkgs, ... }:

let
  cfg = config.programs.imsprog;
in
{
  options.programs.imsprog = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Installs IMSProg and configures udev rules for programmers used by IMSProg.
      '';
    };
    package = lib.mkPackageOption pkgs "imsprog" { };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
  };
}
