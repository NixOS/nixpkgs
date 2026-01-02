{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.whoogle-search;
in
{
  options = {
    services.whoogle-search = {
      enable = lib.mkEnableOption "Whoogle, a metasearch engine";

      port = lib.mkOption {
        type = lib.types.port;
        default = 5000;
        description = "Port to listen on.";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address to listen on for the web interface.";
      };

      extraEnv = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        description = ''
          Extra environment variables to pass to Whoogle, see
          https://github.com/benbusby/whoogle-search?tab=readme-ov-file#environment-variables
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.whoogle-search = {
      description = "Whoogle Search";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.whoogle-search ];

      environment = {
        CONFIG_VOLUME = "/var/lib/whoogle-search";
      }
      // cfg.extraEnv;

      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${lib.getExe pkgs.whoogle-search}"
          + " --host '${cfg.listenAddress}'"
          + " --port '${builtins.toString cfg.port}'";
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
  };

  meta.maintainers = with lib.maintainers; [ malte-v ];
}
