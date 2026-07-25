{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.piper-tts;

in
{
  options = {
    programs.piper-tts = {
      enable = lib.mkEnableOption "Piper TTS";

      package = lib.mkPackageOption pkgs "piper-tts" { };

      voices = mkOption {
        default = _voices: [ ];
        type = types.functionTo (types.listOf types.package);
        defaultText = literalExpression "voices: [ ]";
        example = literalExpression "voices: with voices; [ en_US-amy-low cy_GB-bu_tts-medium ]";
        description = ''
          Voices available to Piper TTS.
        '';
      };

      enableFfplay = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable support for Piper TTS to speak directly in the terminal
          using FFmpeg's ffplay.
        '';
      };

      finalPackage = mkOption {
        type = types.package;
        visible = false;
        readOnly = true;
        description = ''
          The Piper TTS package including any overrides and voices.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    programs.piper-tts.finalPackage =
      let
        allVoices = voices: cfg.voices voices;
      in
      (cfg.package.override {
        withFfplay = cfg.enableFfplay;
        # Alignment data is only surfaced via the Python API or HTTP server,
        # neither of which this module exposes.
        withAlignment = false;
        # Training is a build-time dev workflow, not a TTS runtime feature.
        withTrain = false;
      }).withVoices
        allVoices;

    environment.systemPackages = [ cfg.finalPackage ];
  };

  meta = {
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
