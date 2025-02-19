{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.flashprog;
in
{
  options.programs.flashprog = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Installs flashprog and configures udev rules for programmers
        used by flashprog.
      '';
    };
    package = lib.mkPackageOption pkgs "flashprog" { };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
  };
}
