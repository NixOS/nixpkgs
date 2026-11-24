{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;

  cfg = config.services.zwm-server;
  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "config.json" cfg.settings;

  stateDir = "/var/lib/0wm";
in
{
  options.services.zwm-server = {
    enable = lib.mkEnableOption "0wm-server";
    package = lib.mkPackageOption pkgs "_0wm-server" { };

    openFirewall = mkOption {
      type = types.bool;
      description = ''
        Whether to open the `port` specified in `settings` in the firewall.
      '';
      default = false;
      example = true;
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          interface = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "0WM server address";
          };
          port = mkOption {
            type = types.port;
            default = 8000;
            description = "0WM server port";
          };
          aps = mkOption {
            type = with types; listOf str;
            default = [ ];
            description = "0WM access point addresses";
            example = [
              "http://ap.local"
              "http://127.0.0.1:8003"
            ];
          };
          ssids = mkOption {
            type = with types; listOf str;
            default = [ ];
            description = "WiFi SSIDs";
          };
        };
      };
      default = { };
      description = "0WM config settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zwm-server = {
      description = "0WM Server";
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        DynamicUser = true;
        User = "zwm-server";
        Group = "zwm-server";
        Restart = "on-failure";
        RestartSec = 2;
        StateDirectory = "0wm";
        StateDirectoryMode = "0750";
        RuntimeDirectory = "0wm";
        RuntimeDirectoryMode = "0750";
        UMask = "0007";
      };
      environment = {
        ZWM_SPOOL = stateDir;
        ZWM_SHARE = cfg.package + "/share/0wm";
      };
      unitConfig = {
        StartLimitBurst = 5;
        StartLimitInterval = 100;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        install -m 600 ${configFile} $STATE_DIRECTORY/config
      '';
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [
      cfg.settings.port
    ];
  };
}
