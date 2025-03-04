{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    boolToString
    getExe
    isAttrs
    isBool
    maintainers
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    types
    ;

  cfg = config.services.pairdrop;

  json = pkgs.formats.json { };
in
{
  options.services.pairdrop = {
    enable = mkEnableOption "pairdrop";

    package = mkPackageOption pkgs "pairdrop" { };

    port = mkOption {
      type = types.port;
      default = 3000;
      example = 3010;
      description = "The port to listen on.";
    };

    settings = mkOption {
      description = ''
        Additional configuration (environment variables) for PairDrop, see
        <https://github.com/schlagmichdoch/PairDrop/blob/master/docs/host-your-own.md#environment-variables>
        for supported values.
      '';

      type = types.submodule {
        freeformType =
          with types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);

        options = {
          RTC_CONFIG = mkOption {
            type = types.oneOf [
              json.type
              types.path
            ];
            default = null;
            example = {
              sdpSemantics = "unified-plan";
              iceServers = [
                {
                  urls = "stun:stun.example.com:19302";
                }
              ];
            };
            description = ''
              Configuration for STUN/TURN servers.
              If this is an attribute set, it is converted to JSON and
              written into a file automatically.
              Otherwise, a file path is expected.
            '';
          };
        };
      };

      default = { };

      example = {
        DEBUG_MODE = true;
        RATE_LIMIT = 1;
        IPV6_LOCALIZE = 4;
        WS_FALLBACK = true;
        SIGNALING_SERVER = "pairdrop.net";

        DONATION_BUTTON_ACTIVE = false;
        TWITTER_BUTTON_ACTIVE = false;
        MASTODON_BUTTON_ACTIVE = false;
        BLUESKY_BUTTON_ACTIVE = false;
        CUSTOM_BUTTON_ACTIVE = false;
        PRIVACYPOLICY_BUTTON_ACTIVE = false;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pairdrop =
      let
        rtcConfig = cfg.settings.RTC_CONFIG;
        primitiveSettings = builtins.removeAttrs cfg.settings [ "RTC_CONFIG" ];
        environment =
          {
            PORT = toString cfg.port;
          }
          // (mapAttrs (_: v: if isBool v then boolToString v else toString v) primitiveSettings)
          // optionalAttrs (rtcConfig != null) {
            RTC_CONFIG = if isAttrs rtcConfig then json.generate "rtc-config.json" rtcConfig else rtcConfig;
          };
      in
      {
        inherit environment;

        description = "PairDrop: Transfer Files Cross-Platform";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = getExe cfg.package;

          Type = "simple";
          Restart = "on-failure";
          RestartSec = 3;
          DynamicUser = true;

          # Hardening
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          PrivateUsers = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateMounts = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };
  };

  meta.maintainers = with maintainers; [ diogotcorreia ];
}
