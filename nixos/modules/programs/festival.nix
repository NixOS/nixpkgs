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

  cfg = config.programs.festival;

in
{
  options = {
    programs.festival = {
      enable = lib.mkEnableOption "Festival";

      package = mkOption {
        type = types.package;
        default = pkgs.festival;
        defaultText = "pkgs.festival";
        description = ''
          The Festival package to use.
        '';
      };

      defaultVoice = mkOption {
        type = types.functionTo types.package;
        default = voices: voices.kal_diphone;
        defaultText = literalExpression "voices: voices.kal_diphone";
        example = literalExpression "voices: voices.cmu_us_slt_cg";
        description = ''
          The voice Festival should use by default. The voice is automatically
          included — you do not need to repeat it in {option}`extraVoices`.
        '';
      };

      extraVoices = mkOption {
        default = _voices: [ ];
        type = types.functionTo (types.listOf types.package);
        defaultText = literalExpression "voices: [ ]";
        example = literalExpression "voices: with voices; [ kal_diphone cmu_us_aew ]";
        description = ''
          Extra voices available to Festival.
        '';
      };

      extraSiteInit = mkOption {
        type = types.lines;
        default = "";
        example = ''
          (Parameter.set 'Audio_Method 'Audio_Command)
          (Parameter.set 'Audio_Command "''${alsa-utils}/bin/aplay -q -c 1 -t raw -f s16 -r $SR $FILE")
        '';
        description = ''
          Extra Scheme code to append to Festival's {file}`siteinit.scm`.
          Uses can be found in the Festival manual.
        '';
      };

      speechdSupport = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enables support for interoperability on Festival's side between Festival and speech-dispatcher.
          Note:
           - Do not add too many voices to Festival
           - Festival still needs to be available as a daemon (see {option}`sevices.festival`)
        '';
      };

      finalPackage = mkOption {
        type = types.package;
        visible = false;
        readOnly = true;
        description = ''
          The Festival package including any overrides and extra voices.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    programs.festival.finalPackage =
      let
        defaultVoicePkg = cfg.defaultVoice cfg.package.packages;
        allVoices = voices: cfg.extraVoices voices ++ [ (cfg.defaultVoice voices) ];
      in
      (cfg.package.override { withSpeechdSupport = cfg.speechdSupport; }).withSiteInitConfig allVoices {
        defaultVoice = defaultVoicePkg.passthru.voiceName;
        extraSiteInit = cfg.extraSiteInit;
      };

    environment.systemPackages = [ cfg.finalPackage ];
  };

  meta = {
    maintainers = with lib.maintainers; [ WiredMic ];
  };
}
