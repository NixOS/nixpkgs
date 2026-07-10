{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.kryoflux;

in
{
  options.hardware.kryoflux = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables kryoflux udev rules, ensures 'floppy' group exists. This is a
        prerequisite to using devices supported by kryoflux without being root,
        since kryoflux device descriptors will be owned by floppy through udev.
      '';
    };
    package = lib.mkPackageOption pkgs "kryoflux" { };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
    users.groups.floppy = { };
  };

  meta.maintainers = with lib.maintainers; [ matthewcroughan ];
}
