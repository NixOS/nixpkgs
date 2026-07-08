{
  lib,
  pkgs,
  mkEnableOption,
  mkPackageOption,
  mkOption,
  mkExtraConfigOption,
  ...
}:
{
  type = lib.types.submodule (
    { config, ... }:
    {
      options = {
        enable = mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable eSpeak NG text to speech output module.";
        };

        package = mkPackageOption pkgs "espeak-ng" { };

        debug = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable debug output.";
          example = true;
        };

        soundIconFolder = mkOption {
          type = lib.types.path;
          default = "${pkgs.sound-icons}/share/sounds/sound-icons";
          defaultText = lib.literalExpression ''"''${pkgs.sound-icons}/share/sounds/sound-icons"'';
          description = ''
            Path to a directory containing sound icon WAV files.
            When an application requests a sound icon by name, eSpeak NG will
            look for a matching file in this directory and play it instead of
            speaking the icon name.

            Sets {var}`EspeakSoundIconFolder`.
          '';
          example = lib.literalExpression ''"''${pkgs.sound-icons}/share/sounds/sound-icons"'';
        };

        mbrola = mkOption {
          type = lib.types.bool;
          default = false;
          # FIXME remove when MBROLA voices are fixed in eSpeak
          # https://github.com/NixOS/nixpkgs/pull/541467
          visible = false;
          description = ''
            Enabling this makes eSpeak NG only show MBROLA voices.

            Sets {var}`EspeakMbrola`.
          '';
          example = "true";
        };

        mbrolaPackage = mkPackageOption pkgs "mbrola" { };

        mbrolaVoices = mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          # FIXME remove when MBROLA voices are fixed in eSpeak
          # https://github.com/NixOS/nixpkgs/pull/541467
          visible = false;
          description = ''
            List of MBROLA voice.
            If the list is empty then all voices will be added.
          '';
          example = [
            "en1"
            "de6"
          ];
        };

        mbrolaVoicesPackage = mkPackageOption pkgs "mbrola-voices" { };

        finalPackage = mkOption {
          type = lib.types.package;
          visible = false;
          readOnly = true;
          default =
            if config.mbrola then
              config.package.override {
                mbrolaSupport = true;
                mbrola = config.mbrolaPackage.override {
                  mbrola-voices = config.mbrolaVoicesPackage.override {
                    languages = config.mbrolaVoices;
                  };
                };
              }
            else
              config.package.override {
                mbrolaSupport = false;
              };

          description = ''
            The eSpeak Ng package used by the submodule.
          '';
        };

        extraConfig = mkExtraConfigOption { };
      };
    }
  );

  displayName = "eSpeak NG";
  binary = modCfg: if modCfg.mbrola then "sd_espeak-ng-mbrola" else "sd_espeak-ng";
  confFile = "espeak-ng.conf";
  generateEtc =
    modCfg:
    lib.optionalAttrs modCfg.enable {
      "speech-dispatcher/modules/espeakNg.conf".text = ''
        Debug ${if modCfg.debug then "1" else "0"}
        EspeakSoundIconFolder "${modCfg.soundIconFolder}/"

        EspeakPunctuationList "@+_"
        EspeakCapitalPitchRise 0
        EspeakMinRate 80
        EspeakNormalRate 170
        EspeakMaxRate 449
        EspeakAudioChunkSize 300
        EspeakAudioQueueMaxSize 441000
        EspeakIndexing "1"

        EspeakMbrola ${if modCfg.mbrola then "1" else "0"}
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
          `services.speechd.modules.espeakNg.extraConfig` contains an ${directive} directive.
          Use `services.speechd.modules.espeakNg.${option}` instead.
        '';
      })
      {
        EspeakSoundIconFolder = "soundIconFolder";
        EspeakMbrola = "mbrola";
      }
    ++ [
      {
        assertion = !modCfg.mbrola || modCfg.mbrolaVoices != [ ];
        message = ''
          `services.speechd.modules.espeakNg.mbrola` is enabled.
          However, no voices are set in `services.speechd.modules.espeakNg.mbrolaVoices`.
          This with give a silent error in speechd.
          Either disable `services.speechd.modules.espeakNg.mbrola` or
          place voices in `services.speechd.modules.espeakNg.mbrolaVoices`.
        '';
      }
    ];
}
