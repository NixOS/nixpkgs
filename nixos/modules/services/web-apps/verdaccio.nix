{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  configFileName = "config.yaml";
  cfg = config.services.verdaccio;
  format = pkgs.formats.yaml { };

  mapToSocketsList = lib.pipe lib.attrsets.mapAttrsToList [
    (host: ports: map (port: "${host}:${toString port}") ports)
  ];

  listen = lib.pipe cfg.settings.listen [
    mapToSocketsList
    lib.lists.concatLists
  ];

  configFile = format.generate configFileName (
    if cfg.settings.listen != null then cfg.settings // { inherit listen; } else cfg.settings
  );
in
{
  options.services.verdaccio = {
    enable = mkEnableOption "Verdaccio npm registry";

    settings = mkOption {
      type = types.submodule {
        freeformType = types.anything;
        options = {
          listen = mkOption {
            type = types.nullOr (types.attrsOf (types.listOf types.port));
            default = null;
            description = ''
              Attribute set in which the key is the host and the value is a list of ports.
              This will be used to configure the Verdaccio server to listen on multiple interfaces.
            '';
          };
        };
      };
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
