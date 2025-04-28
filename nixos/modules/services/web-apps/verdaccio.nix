{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.verdaccio;
  format = pkgs.formats.yaml { };
  configFileName = "config.yaml";
  configFile = format.generate configFileName cfg.settings;
in
{
  options.services.verdaccio = {
    enable = mkEnableOption "Verdaccio npm registry";

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Verdaccio configuration options as a Nix attribute set.
        These will be rendered to YAML and used as the Verdaccio configuration.

        Check here https://verdaccio.org/docs/configuration for all available
        configuration options.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nodePackages.verdaccio;
      description = "The Verdaccio package to use.";
    };

    user = mkOption {
      type = types.str;
      default = "verdaccio";
      description = "User under which Verdaccio runs.";
    };

    group = mkOption {
      type = types.str;
      default = "verdaccio";
      description = "Group under which Verdaccio runs.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/verdaccio";
      description = "Directory where Verdaccio stores data.";
    };
  };

  config = mkIf cfg.enable {
    users.users.verdaccio = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
    };

    users.groups.verdaccio = { };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.verdaccio = {
      description = "Verdaccio lightweight npm proxy registry";
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/verdaccio --config /etc/verdaccio/${configFileName}";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
      };
    };

    environment.etc."verdaccio/${configFileName}".source = configFile;
  };
}
