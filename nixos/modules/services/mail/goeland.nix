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
      type = tomlFormat.type;
    };
    schedule = mkOption {
      type = types.str;
      default = "12h";
      example = "Mon, 00:00:00";
      description = mdDoc "How often to run goeland, in systemd time format.";
    };
    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/goeland";
      description = mdDoc ''
        The data directory for goeland where the database will reside if using the unseen filter.
        If left as the default value this directory will automatically be created before the goeland
        server starts, otherwise you are responsible for ensuring the directory exists with
        appropriate ownership and permissions.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.goeland.settings.database = "${cfg.stateDir}/goeland.db";

    systemd.services.goeland = {
      serviceConfig = let confFile = tomlFormat.generate "config.toml" cfg.settings; in mkMerge [
        {
          ExecStart = "${pkgs.goeland}/bin/goeland run -c ${confFile}";
          User = "goeland";
          Group = "goeland";
        }
        (mkIf (cfg.stateDir == "/var/lib/goeland") {
          StateDirectory = "goeland";
          StateDirectoryMode = "0750";
        })
      ];
      startAt = cfg.schedule;
    };

    users.users.goeland = {
      description = "goeland user";
      group = "goeland";
      isSystemUser = true;
    };
    users.groups.goeland = { };

    warnings =
      if hasAttr "password" cfg.settings.email
      then [
        ''
          It is not recommended to set the "services.goeland.settings.email.password"
          option as it will be in cleartext in the Nix store.
          Please use "services.goeland.settings.email.password_file" instead.
        ''
      ]
      else [ ];
  };

  meta.maintainers = with maintainers; [ sweenu ];
}
