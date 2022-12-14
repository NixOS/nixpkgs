{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.goeland;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.services.goeland = {
    enable = mkEnableOption (mdDoc "goeland");

    settings = mkOption {
      description = mdDoc ''
        Configuration of goeland.
        See the [example config file](https://github.com/slurdge/goeland/blob/master/cmd/asset/config.default.toml) for the available options.
      '';
      default = { };
      type = types.submodule {
        freeformType = tomlFormat.type;
      };
    };
    schedule = mkOption {
      type = types.str;
      default = "12h";
      example = "Mon, 00:00:00";
      description = mdDoc "How often to run goeland, in systemd time format";
    };
    databaseDirectory = mkOption {
      type = types.path;
      default = "/var/lib/goeland";
      description = mdDoc "Directory where the goeland database will reside if using the `unseen` filter";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.databaseDirectory} 0750 goeland goeland -" ];

    services.goeland.settings.database = "${cfg.databaseDirectory}/goeland.db";

    systemd.services.goeland = {
      serviceConfig = let confFile = tomlFormat.generate "config.toml" cfg.settings; in {
        ExecStart = "${pkgs.goeland}/bin/goeland run -c ${confFile}";
        User = "goeland";
      };
      startAt = cfg.schedule;
    };

    users.users.goeland = {
      description = "goeland user";
      group = "goeland";
      isSystemUser = true;
    };
    users.groups.goeland = { };
  };

  meta.maintainers = with maintainers; [ sweenu ];
}
