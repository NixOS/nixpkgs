{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dwarffs;
in
{
  options.services.dwarffs = {
    enable = lib.mkEnableOption "a filesystem for fetching debug info on demand";
    package = lib.mkPackageOption pkgs "dwarffs" { };
    maxAge = lib.mkOption {
      type = lib.types.str;
      default = "7d";
      example = "12h";
      description = ''
        Time after which the cached debug info should be cleaned up.
        See {manpage}`tmpfiles.d(5)` for the format.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      variables.NIX_DEBUG_INFO_DIRS = [ "/run/dwarffs" ];
    };
    users = {
      groups.dwarffs = { };
      users.dwarffs = {
        isSystemUser = true;
        group = "dwarffs";
      };
    };
    systemd = {
      automounts = [
        {
          wantedBy = [ "multi-user.target" ];
          where = "/run/dwarffs";
        }
      ];
      packages = [ cfg.package ];
      tmpfiles.rules = [ "d /var/cache/dwarffs 0755 dwarffs dwarffs ${cfg.maxAge}" ];
    };
  };
}
