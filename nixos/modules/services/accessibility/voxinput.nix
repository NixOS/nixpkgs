{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.voxinput;
in
{
  options.services.voxinput = {
    enable = lib.mkEnableOption "VoxInput speech-to-text daemon";

    package = lib.mkPackageOption pkgs "voxinput" { };

    environment = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.str;
      # When updating the documentation see also https://github.com/richiejp/VoxInput/blob/v{pkgs.version}/main.go
      description = ''
        Environment variables to pass to the VoxInput daemon.

        Available options:
        - `OPENAI_BASE_URL` or `VOXINPUT_BASE_URL`: Base URL for the API (default: `http://localhost:8080/v1`).
        - `OPENAI_WS_BASE_URL` or `VOXINPUT_WS_BASE_URL` - WebSocket API base URL (default: ws://localhost:8080/v1/realtime)
        - `VOXINPUT_LANG`: Language code for transcription.
        - `VOXINPUT_TRANSCRIPTION_MODEL`: Model to use (default: `whisper-1`).
        - `VOXINPUT_TRANSCRIPTION_TIMEOUT`: Timeout for transcription (default: `30s`).
        - `VOXINPUT_SHOW_STATUS`: Show desktop notifications (`yes`/`no`, default: `yes`).
        - `VOXINPUT_CAPTURE_DEVICE`: Audio device name.
        - `VOXINPUT_OUTPUT_FILE`: Path to write output instead of simulating keys.
        - You can also set VOXINPUT_API_KEY here if it is not being used for security (e.g. for tracking, preventing accidental requests), otherwise use the credentialsEnvFile

        See <https://github.com/richiejp/VoxInput/tree/v0.8.0> for more details.
      '';
    };

    credentialsEnvFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to a file containing the `OPENAI_API_KEY` or `VOXINPUT_API_KEY`; in the format of
        an EnvironmentFile=, as described by {manpage}`systemd.exec(5)`

        All other environment variables can be set in this way as well.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.voxinput = {
      description = "VoxInput speech-to-text daemon";

      after = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/voxinput listen";
        RuntimeDirectory = "voxinput";
        Restart = "on-failure";
        RestartSec = 5;
      }
      // lib.optionalAttrs (cfg.credentialsEnvFile != null) {
        EnvironmentFile = [ cfg.credentialsEnvFile ];
      };

      environment = cfg.environment;
    };
  };
}
