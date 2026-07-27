{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.services.piper-tts;
  progCfg = config.programs.piper-tts;
in
{
  options.services.piper-tts = {
    enable = lib.mkEnableOption "the Piper TTS server";

    package = lib.mkPackageOption pkgs "piper-tts" { };

    voices = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = progCfg.voices or (voices: with voices; [ en_US-amy-low ]);
      defaultText = lib.literalExpression ''
        if config.programs.piper-tts.enable
        then config.programs.piper-tts.voices
        else voices: with voices; [ en_US-amy-low ]
      '';
      description = ''
        The set of voices available to the Piper TTS server.
        This option will take the voices from {option}`programs.piper-tts.voices`
        if {option}`programs.piper-tts` is enabled.
        However, it can always be overridden.
      '';
      example = lib.literalExpression "voices: with voices; [ en_US-amy-medium en_GB-alan-medium ]";
    };

    defaultVoice = mkOption {
      type = types.package;
      default = pkgs.piperTtsVoices.voices.en_US-amy-low;
      defaultText = lib.literalExpression "pkgs.piperTtsVoices.voices.en_US-amy-low";
      description = ''
        The voice used as the server's default (`-m`/`--model`).

        Will alway be available regardless of what
        {option}`services.piper-tts.voices` is.
      '';
      example = lib.literalExpression "pkgs.piperTtsVoices.voices.en_US-amy-medium";
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Host address for the Piper TTS server to listen on.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 5000;
      description = ''
        Port for the Piper TTS server to listen on.
      '';
    };

    debug = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable debug logging for the Piper TTS server.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open port {option}`services.piper-tts.port` in the firewall.
      '';
    };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      description = ''
        The Piper TTS package used by the server.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.piper-tts.finalPackage =
      let
        allVoices = voices: lib.unique (cfg.voices voices ++ [ cfg.defaultVoice ]);
      in
      (cfg.package.override {
        # Training is a build-time dev workflow, not a TTS runtime feature.
        withTrain = false;
        withHTTP = true;
        withAlignment = true;
        withFfplay = false;
      }).withVoices
        allVoices;

    systemd.user.services.piper-tts = {
      description = "Piper TTS speech synthesis server";
      wantedBy = [ "default.target" ];
      restartTriggers = [ cfg.finalPackage ];
      serviceConfig = {
        ExecStart = lib.concatStringsSep " " (
          [
            "${cfg.finalPackage}/bin/piper-server"
            "--host ${cfg.host}"
            "--port ${toString cfg.port}"
            "-m ${lib.escapeShellArg cfg.defaultVoice.key}"
          ]
          ++ lib.optional cfg.debug "--debug"
        );
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
