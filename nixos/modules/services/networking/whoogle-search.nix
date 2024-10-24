{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.whoogle-search;
in
{
  options = {
    services.whoogle-search = {
      enable = mkEnableOption "Whoogle, a metasearch engine";

      port = mkOption {
        type = types.port;
        default = 5000;
        description = "Port to listen on.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address to listen on for the web interface.";
      };

      httpsOnly = mkOption {
        type = types.bool;
        default = false;
        description = "Enforce HTTPS redirects for all requests.";
      };

      extraEnv = mkOption {
        type = with types; attrsOf str;
        default = { };
        description = ''
          Extra environment variables to pass to Whoogle, see
          https://github.com/benbusby/whoogle-search?tab=readme-ov-file#environment-variables
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.whoogle-search = {
      description = "Whoogle Search";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.whoogle-search ];

      environment = {
        CONFIG_VOLUME = "/var/lib/whoogle-search";
      } // cfg.extraEnv;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.whoogle-search}/bin/whoogle-search"
          + " --host '${cfg.listenAddress}'"
          + " --port '${builtins.toString cfg.port}'"
          + optionalString (cfg.httpsOnly) " --https-only";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        StateDirectory = "whoogle-search";
        StateDirectoryMode = "0750";
        DynamicUser = true;
        PrivateTmp = true;
        ProtectSystem = true;
        ProtectHome = true;
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    meta.maintainers = with maintainers; [ malte-v ];
  };
}
