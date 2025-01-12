{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    types
    ;

  cfg = config.services.ustreamer;
in
{
  options.services.ustreamer = {
    enable = mkEnableOption "µStreamer, a lightweight MJPEG-HTTP streamer";

    package = mkPackageOption pkgs "ustreamer" { };

    autoStart = mkOption {
      description = ''
        Wether to start µStreamer on boot. Disabling this will use socket
        activation. The service will stop gracefully after some inactivity.
        Disabling this will set `--exit-on-no-clients=300`
      '';
      type = types.bool;
      default = true;
      example = false;
    };

    listenAddress = mkOption {
      description = ''
        Address to expose the HTTP server. This accepts values for
        ListenStream= defined in {manpage}`systemd.socket(5)`
      '';
      type = types.str;
      default = "0.0.0.0:8080";
      example = "/run/ustreamer.sock";
    };

    device = mkOption {
      description = ''
        The v4l2 device to stream.
      '';
      type = types.path;
      default = "/dev/video0";
      example = "/dev/v4l/by-id/usb-0000_Dummy_abcdef-video-index0";
    };

    extraArgs = mkOption {
      description = ''
        Extra arguments to pass to `ustreamer`. See {manpage}`ustreamer(1)`
      '';
      type = with types; listOf str;
      default = [ ];
      example = [ "--resolution=1920x1080" ];
    };
  };

  config = mkIf cfg.enable {
    services.ustreamer.extraArgs =
      [
        "--device=${cfg.device}"
      ]
      ++ optionals (!cfg.autoStart) [
        "--exit-on-no-clients=300"
      ];

    systemd.services."ustreamer" = {
      description = "µStreamer, a lightweight MJPEG-HTTP streamer";
      after = [ "network.target" ];
      requires = [ "ustreamer.socket" ];
      wantedBy = mkIf cfg.autoStart [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (getExe cfg.package)
            "--systemd"
          ]
          ++ cfg.extraArgs
        );
        Restart = if cfg.autoStart then "always" else "on-failure";

        DynamicUser = true;
        SupplementaryGroups = [ "video" ];

        NoNewPrivileges = true;
        ProcSubset = "pid";
        ProtectProc = "noaccess";
        ProtectClock = "yes";
        DeviceAllow = [ cfg.device ];
      };
    };

    systemd.sockets."ustreamer" = {
      wantedBy = [ "sockets.target" ];
      partOf = [ "ustreamer.service" ];
      socketConfig = {
        ListenStream = cfg.listenAddress;
      };
    };
  };
}
