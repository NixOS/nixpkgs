{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.artalk;
  settingsFormat = pkgs.formats.json { };
in
{

  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };

  options = {
    services.artalk = {
      enable = lib.mkEnableOption "artalk, a comment system";
      configFile = lib.mkOption {
        type = lib.types.path;
        default = "/etc/artalk/config.yml";
        description = "Artalk config file path. If it is not exist, Artalk will generate one.";
      };
      allowModify = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "allow Artalk store the settings to config file persistently";
      };
      workdir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/artalk";
        description = "Artalk working directory";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "artalk";
        description = "Artalk user name.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "artalk";
        description = "Artalk group name.";
      };

      package = lib.mkPackageOption pkgs "artalk" { };
      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "0.0.0.0";
              description = ''
                Artalk server listen host
              '';
            };
            port = lib.mkOption {
              type = lib.types.port;
              default = 23366;
              description = ''
                Artalk server listen port
              '';
            };
          };
        };
        default = { };
        description = ''
          The artalk configuration.

          If you set allowModify to true, Artalk will be able to store the settings in the config file persistently. This section's content will update in the config file after the service restarts.

          Options containing secret data should be set to an attribute set
          containing the attribute `_secret` - a string pointing to a file
          containing the value the option should be set to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.artalk = lib.optionalAttrs (cfg.user == "artalk") {
      description = "artalk user";
      isSystemUser = true;
      group = cfg.group;
    };
    users.groups.artalk = lib.optionalAttrs (cfg.group == "artalk") { };

    environment.systemPackages = [ cfg.package ];

    systemd.services.artalk = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        umask 0077
        ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/artalk/new"}
      ''
      + (
        if cfg.allowModify then
          ''
            [ -e "${cfg.configFile}" ] || ${lib.getExe cfg.package} gen config "${cfg.configFile}"
            cat "${cfg.configFile}" | ${lib.getExe pkgs.yj} > "/run/artalk/old"
            ${lib.getExe pkgs.jq} -s '.[0] * .[1]' "/run/artalk/old" "/run/artalk/new" > "/run/artalk/result"
            cat "/run/artalk/result" | ${lib.getExe pkgs.yj} -r > "${cfg.configFile}"
            rm /run/artalk/{old,new,result}
          ''
        else
          ''
            cat /run/artalk/new | ${lib.getExe pkgs.yj} -r > "${cfg.configFile}"
            rm /run/artalk/new
          ''
      );
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} server --config ${cfg.configFile} --workdir ${cfg.workdir} --host ${cfg.settings.host} --port ${builtins.toString cfg.settings.port}";
        Restart = "on-failure";
        RestartSec = "5s";
        ConfigurationDirectory = [ "artalk" ];
        StateDirectory = [ "artalk" ];
        RuntimeDirectory = [ "artalk" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        ProtectHome = "yes";
      };
    };
  };
}
