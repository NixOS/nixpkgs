{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkOption
    mkIf
    mkRemovedOptionModule
    ;

  cfg = config.services.mtprotoproxy;

  settingsFormat = pkgs.formats.pythonVars { };
  configFile = settingsFormat.generate "config.py" cfg.settings;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "mtprotoproxy" "port" ] ''
      The mtprotoproxy module now uses RFC-42-style settings, please use
      `services.mtprotoproxy.settings.PORT` instead.
    '')
    (mkRemovedOptionModule [ "services" "mtprotoproxy" "adTag" ] ''
      The mtprotoproxy module now uses RFC-42-style settings, please use
      `services.mtprotoproxy.settings.AD_TAG` instead.
    '')
    (mkRemovedOptionModule [ "services" "mtprotoproxy" "users" ] ''
      The mtprotoproxy module now uses RFC-42-style settings, please use
      `services.mtprotoproxy.settings.USERS` instead.
    '')
    (mkRemovedOptionModule [ "services" "mtprotoproxy" "secureOnly" ] ''
      The mtprotoproxy module now uses RFC-42-style settings, please use
      `services.mtprotoproxy.settings.SECURE_ONLY` instead.
    '')
  ];

  options = {
    services.mtprotoproxy = {
      enable = mkEnableOption "mtprotoproxy";

      settings = mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            PORT = mkOption {
              type = types.port;
              default = 3256;
              description = ''
                TCP port to accept mtproto connections on.
              '';
            };

            USERS = mkOption {
              type = types.attrsOf types.str;
              example = {
                tg = "00000000000000000000000000000000";
                tg2 = "0123456789abcdef0123456789abcdef";
              };
              description = ''
                Allowed users and their secrets. A secret is a 32 characters long hex string.
              '';
            };

            SECURE_ONLY = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Don't allow users to connect in non-secure mode (without random padding).
              '';
            };

            AD_TAG = mkOption {
              type = types.str;
              default = "";
              # Taken from mtproxyproto's repo.
              example = "3c09c680b76ee91a4c25ad51f742267d";
              description = ''
                Tag for advertising that can be obtained from @MTProxybot.
              '';
            };
          };
        };

        description = ''
          Python variables to set for the service.

          Refer to <https://github.com/alexbers/mtprotoproxy/blob/master/config.py> for a example config.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mtprotoproxy = {
      description = "MTProto Proxy Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mtprotoproxy}/bin/mtprotoproxy ${configFile}";
        DynamicUser = true;
      };
    };
  };
}
