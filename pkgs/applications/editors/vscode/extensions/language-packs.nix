{ lib, vscode-utils }:

with vscode-utils;

let

  buildVscodeLanguagePack = { language, sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-language-pack-${language}";
        publisher = "MS-CEINTL";
        version = "1.64.3";
        inherit sha256;
      };
      meta = {
        license = lib.licenses.mit;
      };
    };

in

# See list of core language packs at https://github.com/Microsoft/vscode-loc
{
  # French
  vscode-language-pack-fr = buildVscodeLanguagePack {
    language = "fr";
    sha256 = "sha256-6ynT1sbMgKO8iZReQ6KxFpR1VL3Nuo58MvXCtp+67vA=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    sha256 = "sha256-5aNFpzNMZAZJH3n0rJevke9P6AW0au5i8+r4PXsb9Rg=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    sha256 = "sha256-oEaWtsgktHKw52lnZTESkpzC/TTY8LO4yX11IgtMG5U=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    sha256 = "sha256-utLWbved3WCCk3XzqedbYzmyaKfbMrAmR0btT09GlxA=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    sha256 = "sha256-0Wr2ICOiaaj4jZ555bxUJcmXO/yWDyn0UmdvxUF3WSQ=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    sha256 = "sha256-irTSQcVXf/V3MuZwfx4tFcvBk+xhbFZTnb7IG28s/p4=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    sha256 = "sha256-3IA/VTTTEqS6jrDYv50GnLXOTSC1XAMvqOVfOuvIdIs=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    sha256 = "sha256-rxod70ddrppEYYzukksVY1dTXR8osLFAsIPr1fSFZDg=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    sha256 = "sha256-QYFaxJz1PqKKIiLosLQ8Tu3JNXzpxLFqgIHjjRLwjA4=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    sha256 = "sha256-eMk+syy2h+Xb3k6QB8PqYaF4I1ydaY6eRsvOXmelh9Q=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    sha256 = "sha256-7Trz38KBl4sD7608MvTs02pUsdD05oHEj3Sp1LvtI7I=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    sha256 = "sha256-T4CTpbve3vrNdW4VDfHDg8U8cQEtuxPV5LvNdtKrqzA";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    sha256 = "sha256-rPvCr3uQPfM8vwKoV7Un5aiMZClhf6TvG1PEe3xYNI0=";
  };
}
