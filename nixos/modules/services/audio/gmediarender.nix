{
  pkgs,
  lib,
  config,
  utils,
  ...
}:
let
  cfg = config.services.gmediarender;
in
{
  options.services.gmediarender = {
    enable = lib.mkEnableOption "the gmediarender DLNA renderer";

    audioDevice = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The audio device to use.
      '';
    };

    audioSink = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The audio sink to use.
      '';
    };

    friendlyName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        A "friendly name" for identifying the endpoint.
      '';
    };

    initialVolume = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = 0;
      description = ''
        A default volume attenuation (in dB) for the endpoint.
      '';
    };

    package = lib.mkPackageOption pkgs "gmediarender" {
      default = "gmrender-resurrect";
    };

    port = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = "Port that will be used to accept client connections.";
    };

    uuid = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        A UUID for uniquely identifying the endpoint.  If you have
        multiple renderers on your network, you MUST set this.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.gmediarender = {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "gmediarender server daemon";
        environment = {
          XDG_CACHE_HOME = "%t/gmediarender";
        };
        serviceConfig = {
          DynamicUser = true;
          User = "gmediarender";
          Group = "gmediarender";
          SupplementaryGroups = [ "audio" ];
          ExecStart =
            "${cfg.package}/bin/gmediarender "
            + lib.optionalString (cfg.audioDevice != null) (
              "--gstout-audiodevice=${utils.escapeSystemdExecArg cfg.audioDevice} "
            )
            + lib.optionalString (cfg.audioSink != null) (
              "--gstout-audiosink=${utils.escapeSystemdExecArg cfg.audioSink} "
            )
            + lib.optionalString (cfg.friendlyName != null) (
              "--friendly-name=${utils.escapeSystemdExecArg cfg.friendlyName} "
            )
            + lib.optionalString (cfg.initialVolume != 0) ("--initial-volume=${toString cfg.initialVolume} ")
            + lib.optionalString (cfg.port != null) ("--port=${toString cfg.port} ")
            + lib.optionalString (cfg.uuid != null) ("--uuid=${utils.escapeSystemdExecArg cfg.uuid} ");
          Restart = "always";
          RuntimeDirectory = "gmediarender";

          # Security options:
          CapabilityBoundingSet = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          # PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          UMask = 66;
        };
      };
    };
  };
}
