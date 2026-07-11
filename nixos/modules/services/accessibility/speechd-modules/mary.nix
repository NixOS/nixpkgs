{
  lib,
  pkgs,
  mkEnableOption,
  mkOption,
  mkExtraConfigOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkEnableOption "Mary text to speech output module";

      port = mkOption {
        type = lib.types.port;
        default = 59125;
        description = ''
          MaryTTS server port.

          Set the {var}`GenericPortDependency`.
        '';
        example = 44545;
      };

      host = mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          MaryTTS server host address.

          Sets the host in the {var}`GenericExecuteSynth` curl command.
        '';
        example = "192.168.1.10";
      };

      defaultVoice = mkOption {
        type = lib.types.str;
        default = "dfki-spike";
        description = ''
          Default MaryTTS voice to use.
          Must match a voice name from an {var}`AddVoice` directive.

          Sets {var}`DefaultVoice`.
        '';
        example = "cmu-slt";
      };

      debug = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable debug output.
        '';
        example = true;
      };

      extraConfig = mkExtraConfigOption { };
    };
  };

  displayName = "MaryTTS";
  confFile = "mary-generic.conf";
  generateEtc =
    modCfg:
    let
      mktemp = "${pkgs.coreutils}/bin/mktemp";
      curl = "${pkgs.curl}/bin/curl";
      xxd = "${pkgs.tinyxxd}/bin/xxd";
      tr = "${pkgs.coreutils}/bin/tr";
      sed = "${pkgs.gnused}/bin/sed";
      sox = "${pkgs.sox}/bin/sox";
    in
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/mary.conf".text = ''
        Debug ${if modCfg.debug then "1" else "0"}

        GenericExecuteSynth "tmp=$(${mktemp} --suffix=.wav) && \
        ${curl} \"http://${modCfg.host}:${toString modCfg.port}/process?INPUT_TEXT=`printf %s \'$DATA\' | ${xxd} -plain | \
        ${tr} -d '\\n' | ${sed} 's/\\\(..\\\)/%\\\1/g'`&INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&AUDIO=WAVE_FILE&LOCALE=$LANGUAGE&VOICE=$VOICE\" | \
        ${sox} -v $VOLUME \"$tmp\" tempo $RATE pitch $PITCH norm && $PLAY_COMMAND \"$tmp\"; \
        rm -f \"$tmp\""

        GenericCmdDependency "${curl}"
        GenericPortDependency ${toString modCfg.port}
        GenericSoundIconFolder "${pkgs.sound-icons}/share/sounds/sound-icons/"

        GenericPunctNone ""
        GenericPunctSome "--punct=\"()[]{};:\""
        GenericPunctMost "--punct=\"()[]{};:\""
        GenericPunctAll "--punct"

        GenericLanguage  "en" "en_GB" "utf-8"
        GenericLanguage  "en" "en_US" "utf-8"

        GenericDefaultCharset "utf-8"

        #English GB
        AddVoice        "en_GB"    "MALE1"         "dfki-spike"
        AddVoice        "en_GB"    "FEMALE1"       "dfki-prudence"
        AddVoice        "en_GB"    "CHILD_FEMALE"  "dfki-poppy"
        AddVoice        "en_GB"    "MALE2"         "dfki-obadiah"

        #English US
        AddVoice        "en_US"    "MALE1"         "cmu-bdl"
        AddVoice        "en_US"    "MALE2"         "cmu-rms"
        AddVoice        "en_US"    "FEMALE1"       "cmu-slt"

        #German
        AddVoice        "de"    "MALE1"         "dfki-pavoque-styles"
        AddVoice        "de"    "FEMALE1"       "bits1"
        AddVoice        "de"    "MALE2"         "bits2"
        AddVoice        "de"    "MALE3"         "bits3"
        AddVoice        "de"    "FEMALE2"       "bits4"
        AddVoice        "de"    "MALE4"         "dfki-pavoque-neutral"

        #Turkish
        AddVoice        "tr"    "MALE1"         "dfki-ot"

        #French
        AddVoice        "fr"    "FEMALE1"       "upmc-jessica"
        AddVoice        "fr"    "MALE1"         "upmc-pierre"
        AddVoice        "fr"    "FEMALE2"       "enst-camille"
        AddVoice        "fr"    "MALE2"         "enst-dennys-hsmm"

        #Telugu
        AddVoice        "te"    "FEMALE1"       "cmu-nk-hsmm"

        #Italian
        AddVoice        "it"    "FEMALE1"       "istc-lucia-hsmm"

        DefaultVoice ${modCfg.defaultVoice}

        GenericRateAdd          1
        GenericPitchAdd         1
        GenericVolumeAdd        1

        GenericRateMultiply     1
        GenericPitchMultiply 750
        GenericVolumeMultiply 2

        GenericRateForceInteger     0
        GenericPitchForceInteger    1
        GenericVolumeForceInteger   0
      ''
      + "\n"
      + modCfg.extraConfig;
    };

  assertions =
    modCfg:
    lib.mapAttrsToList
      (directive: option: {
        assertion = !(lib.hasInfix directive modCfg.extraConfig);
        message = ''
          `services.speechd.modules.mary.extraConfig` contains an ${directive} directive.
          Use `services.speechd.modules.mary.${option}` instead.
        '';
      })
      {
        GenericPortDependency = "port";
      };
}
