{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.pdnsd;
  pdnsd = pkgs.pdnsd;
  pdnsdUser = "pdnsd";
  pdnsdGroup = "pdnsd";
  pdnsdConf = pkgs.writeText "pdnsd.conf"
    ''
      global {
        run_as=${pdnsdUser};
        cache_dir="${cfg.cacheDir}";
        ${cfg.globalConfig}
      }

      server {
        ${cfg.serverConfig}
      }
      ${cfg.extraConfig}
    '';
in

{ options =
    { services.pdnsd =
        { enable = mkEnableOption "pdnsd";

          cacheDir = mkOption {
            type = types.str;
            default = "/var/cache/pdnsd";
            description = "Directory holding the pdnsd cache";
          };

          globalConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Global configuration that should be added to the global directory
              of <literal>pdnsd.conf</literal>.
            '';
          };

          serverConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Server configuration that should be added to the server directory
              of <literal>pdnsd.conf</literal>.
            '';
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Extra configuration directives that should be added to
              <literal>pdnsd.conf</literal>.
            '';
          };
        };
    };

  config = mkIf cfg.enable {
    users.extraUsers = singleton {
      name = pdnsdUser;
      uid = config.ids.uids.pdnsd;
      group = pdnsdGroup;
      description = "pdnsd user";
    };

    users.extraGroups = singleton {
      name = pdnsdGroup;
      gid = config.ids.gids.pdnsd;
    };

    systemd.services.pdnsd =
      { wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        preStart =
          ''
            mkdir -p "${cfg.cacheDir}"
            touch "${cfg.cacheDir}/pdnsd.cache"
            chown -R ${pdnsdUser}:${pdnsdGroup} "${cfg.cacheDir}"
          '';
        description = "pdnsd";
        serviceConfig =
          {
            ExecStart = "${pdnsd}/bin/pdnsd -c ${pdnsdConf}";
          };
      };
  };
}
