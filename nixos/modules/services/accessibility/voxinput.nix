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
    enable = lib.mkEnableOption "VoxInput speech-to-text daemon and voice assistant";

    package = lib.mkPackageOption pkgs "voxinput" { };

    environment = lib.mkOption {
      default = { };
      type = lib.types.attrs;
      # When updating the documentation see also https://github.com/richiejp/VoxInput/blob/main/main.go
      description = ''
        Environment variables to pass to the VoxInput daemon.
        `VOXINPUT_*` prefixed variables take precedence over their `OPENAI_*` counterparts.

        API configuration:
        - `VOXINPUT_BASE_URL` or `OPENAI_BASE_URL`: HTTP API base URL (default: `http://localhost:8080/v1`).
        - `VOXINPUT_WS_BASE_URL` or `OPENAI_WS_BASE_URL`: WebSocket API base URL (default: `ws://localhost:8080/v1/realtime`).

        Note that you can use LocalAI to run models locally or any OpenAI realtime API compatible service.

        Transcription configuration:
        - `VOXINPUT_LANG`: Language code for transcription (full string, takes precedence over `LANG`).
        - `VOXINPUT_TRANSCRIPTION_MODEL`: Transcription model name (default: `whisper-1`).
        - `VOXINPUT_TRANSCRIPTION_TIMEOUT`: Timeout for transcription requests (default: `30s`).
        - `VOXINPUT_PROMPT`: Conditioning text for the transcription model.

        Assistant mode configuration:
        - `VOXINPUT_MODE`: Realtime mode, `transcription` or `assistant` (default: `transcription`).
        - `VOXINPUT_ASSISTANT_MODEL`: LLM model for assistant mode (default: server default).
        - `VOXINPUT_ASSISTANT_VOICE`: TTS voice for assistant responses (default: `alloy`).
        - `VOXINPUT_ASSISTANT_INSTRUCTIONS`: System prompt for the assistant model.
        - `VOXINPUT_ASSISTANT_ENABLE_DOTOOL`: Enable dotool function in assistant mode, `yes`/`no` (default: `yes`).
        - `VOXINPUT_ASSISTANT_SCREENSHOT_COMMAND`: Command to capture a screenshot (e.g. `grim /tmp/screenshot.png`).
        - `VOXINPUT_ASSISTANT_SCREENSHOT_FILE`: Path where the screenshot command saves its file.

        Audio configuration:
        - `VOXINPUT_INPUT_SAMPLE_RATE`: Audio input sample rate in Hz (default: `24000`).
        - `VOXINPUT_OUTPUT_SAMPLE_RATE`: Audio output sample rate in Hz (default: `24000`).
        - `VOXINPUT_CAPTURE_DEVICE`: Audio capture device name (run `voxinput devices` to list).

        UI and output:
        - `VOXINPUT_SHOW_STATUS`: Show desktop notifications, `yes`/`no` (default: `yes`).
        - `VOXINPUT_OUTPUT_FILE`: Path to write transcribed text instead of typing via dotool.

        You can also set `VOXINPUT_API_KEY` here if it is not being used for security
        (e.g. for tracking, preventing accidental requests), otherwise use
        {option}`services.voxinput.credentialsEnvFile`.

        See <https://github.com/richiejp/VoxInput#usage> for more details.
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
        ExecStart = "${lib.getExe cfg.package} listen";
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
