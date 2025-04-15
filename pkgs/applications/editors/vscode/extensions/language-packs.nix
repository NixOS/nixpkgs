{
  lib,
  vscode-utils,
  writeShellScript,
  nix-update,
  vscode-extensions-update,
}:

with vscode-utils;

let

  buildVscodeLanguagePack =
    {
      language,
      version ? "1.99.2025040209",
      hash,
    }:
    buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-language-pack-${language}";
        publisher = "MS-CEINTL";
        inherit version hash;
      };
      passthru.updateScript = lib.optionalAttrs (language == "fr") (
        writeShellScript "vscode-language-packs-update-script" ''
          ${lib.getExe vscode-extensions-update} vscode-extensions.ms-ceintl.vscode-language-pack-fr --override-filename "pkgs/applications/editors/vscode/extensions/language-packs.nix"
          for lang in cs de es it ja ko pl pt-br qps-ploc ru tr zh-hans zh-hant; do
            ${lib.getExe nix-update} --version "skip" "vscode-extensions.ms-ceintl.vscode-language-pack-$lang" --override-filename "pkgs/applications/editors/vscode/extensions/language-packs.nix"
          done
        ''
      );
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
    hash = "sha256-QQHaNifN6ol6dnmuLZcIv74g8gbAWJgQBX4BPNx1bgM=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-b8HVmF9Wf4jLpaHMK+9EuCayMLxAKyPRJpohBNTDk7I=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-e7slPjnns7Y3GwmYDKjvIi7eJBkrBUG6KTnUJFoz0nk=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-OtxIM70wTLkgxFN6s4myLGe2fdjVG3p13tYko0MzhUc=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-JLcQ2JVR7eFThgKrabQPo0Z27AigWfeHVY+lW2ZY1es=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-oUb3nj67HBAavB6b0XLgwpbQO2aZ9HMF42Rdw53Z9B4=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-1ESY/7woVrPN/PITD2T0/Cm9zFKDyYcGy4x1/oBxZeE=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-nHeWIcipl/nztwPkUTzetO5eGTVEaEp7oW3a31c5Obo=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-R/mbXCUsVTYhRpvCUr44jbDvYWYKqBXF4kr+TRl/MeU=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-oVpGg7OMZ+8WrO2vGzmwF2mDwTaRGYvM1kOXEtmFvdw=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-cY1hGBNeTa3rul8ZtvtZW2PCLp0MZwugufdLTaI7rx0=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-DzPerwuqvHk4G5/AcrXLJh0PINd5HK+TelO9C4EOdVc=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-9UilVHsAWCZq6N6sqrGpnIEzjCBfalBL9LgCfEGFLvU=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-lYS+uje6eLUr7J7diq2Lkh3xjhPKWdU+ccwVQrOs75g=";
  };
}
