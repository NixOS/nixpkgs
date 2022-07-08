{ config, lib, pkgs, ... }:


let
  cfg = config.services.whoogle-search;
  stateDir = "/var/lib/whoogle-search";
in
{
  options = with lib; {
    services.whoogle-search = {
      enable = mkEnableOption (mdDoc "whoogle-search service");

      port = mkOption {
        type = types.port;
        default = 5000;
        description = mdDoc "Port to listen on.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = mdDoc "Address to listen on for the web interface.";
      };

      dataDir = mkOption {
        type = types.path;
        default = stateDir;
        description = mdDoc ''
          The directory where whoogle-search will create session files.

          If left as the default value this directory will automatically be
          created before whoogle-search starts, otherwise the sysadmin is
          responsible for ensuring the directory exists with appropriate
          ownership and permissions.
        '';
      };

      httpsOnly = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc "Enforce HTTPS redirects for all requests.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.whoogle-search = {
      description = "Whoogle Search";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.whoogle-search ];

      preStart = ''
        if [ ! -d '${cfg.dataDir}/static' ]; then
          cp -r '${pkgs.whoogle-search}/${pkgs.python3.sitePackages}/app/static_runtime' '${cfg.dataDir}/static'
        fi

        # The build directory must be writable to store the session static files
        chmod 0755 '${cfg.dataDir}/static/build'
      '';

      environment = {
        CONFIG_VOLUME = cfg.dataDir;
      };

      serviceConfig = lib.mkMerge [
        {
          Type = "simple";
          DynamicUser = true;
          ExecStart = "${pkgs.whoogle-search}/bin/whoogle-search"
            + " --host '${cfg.listenAddress}'"
            + " --port '${builtins.toString cfg.port}'"
            + lib.optionalString (cfg.httpsOnly) " --https-only";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          PrivateTmp = true;
          ProtectSystem = true;
          ProtectHome = true;
          Restart = "on-failure";
          RestartSec = "5s";

          ReadWritePaths = [ cfg.dataDir ];
        }
        (lib.mkIf (cfg.dataDir == stateDir) {
          StateDirectory = "whoogle-search";
          StateDirectoryMode = "0750";
        })
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [ seberm ];
}
