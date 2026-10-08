{
  lib,
  stdenv,
  fetchgit,
}:

let
  mkDictFromChromium =
    {
      shortName,
      dictFileName,
      shortDescription,
    }:
    stdenv.mkDerivation {
      pname = "hunspell-dict-${shortName}-chromium";
      version = "155.0.8059.39";

      src = fetchgit {
        url = "https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries";
        rev = "cee14e319bb7603a1157bb4d1e216be64ee82b77";
        hash = "sha256-9ySOaTS70biP/2tnlby6+L755TRuPIM4lL64aE2E/l4=";
      };

      dontBuild = true;

      installPhase = ''
        cp ${dictFileName} $out
      '';

      passthru = {
        # As chromium needs the exact filename in ~/.config/chromium/Dictionaries,
        # this value needs to be known to tools using the package if they want to
        # link the file correctly.
        inherit dictFileName;

        updateScript = ./update-chromium-dictionaries.py;
      };

      meta = {
        homepage = "https://chromium.googlesource.com/chromium/deps/hunspell_dictionaries/";
        description = "Chromium compatible hunspell dictionary for ${shortDescription}";
        longDescription = ''
          Humspell directories in Chromium's custom bdic format

          See https://www.chromium.org/developers/how-tos/editing-the-spell-checking-dictionaries/
        '';
        license = with lib.licenses; [
          gpl2
          lgpl21
          mpl11
          lgpl3
        ];
        maintainers = with lib.maintainers; [ networkexception ];
        platforms = lib.platforms.all;
      };
    };
in
rec {

  inherit mkDictFromChromium;

  # ENGLISH

  en_US = en-us;
  en-us = mkDictFromChromium {
    shortName = "en-us";
    dictFileName = "en-US-10-1.bdic";
    shortDescription = "English (United States)";
  };

  en_GB = en-us;
  en-gb = mkDictFromChromium {
    shortName = "en-gb";
    dictFileName = "en-GB-10-1.bdic";
    shortDescription = "English (United Kingdom)";
  };

  # GERMAN

  de_DE = de-de;
  de-de = mkDictFromChromium {
    shortName = "de-de";
    dictFileName = "de-DE-3-0.bdic";
    shortDescription = "German (Germany)";
  };

  # FRENCH

  fr_FR = fr-fr;
  fr-fr = mkDictFromChromium {
    shortName = "fr-fr";
    dictFileName = "fr-FR-3-0.bdic";
    shortDescription = "French (France)";
  };

  # SWEDISH

  sv_SE = sv-se;
  sv-se = mkDictFromChromium {
    shortName = "sv-se";
    dictFileName = "sv-SE-3-0.bdic";
    shortDescription = "Swedish (Sweden)";
  };
}
