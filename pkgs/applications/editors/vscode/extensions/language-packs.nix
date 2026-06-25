{
  lib,
  vscode-utils,
  writeShellScript,
  nix-update,
  vscode-extension-update,
}:

with vscode-utils;

let

  buildVscodeLanguagePack =
    {
      language,
      version ? "1.125.2026061612",
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
          ${lib.getExe vscode-extension-update} vscode-extensions.ms-ceintl.vscode-language-pack-fr --override-filename "pkgs/applications/editors/vscode/extensions/language-packs.nix"
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
    hash = "sha256-94NQRf905+w5HwkREUiBZkSlKPAcNRImnbMJy97a5fE=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-AtFqGJ2qI97otfgU7iVpjwVr1kFOzFDsc0VBIG6ymII=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-P4yCuo9MDhF9fqfwe184c6Rzf7MnQpXdIjqosicMZQc=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-vX38PctRoG0uJss3zWksZ3ALp253hlT3p6QPysjP2Xw=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-Ic750Z1dDoHoFHgIcepZjhMSqTjZuvoHPhU8zmjUx4g=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-wxaHK4WpURp1JIf9h/ykUVQPfSgxidmw0n3DQUblhfo=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-XkMJ2vcVkEjU20RSMnlmx2tkviKNE5kW9xo3H8rg1Zc=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-fpeCN0xtChU6MfimTeu8O0uhKnR95LEaSCyiynxCQCM=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-O+8F6TohWsFlx7Z2xjZR/gDq3SIvjWHMq4RJr5jZtq8=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-PTIq67A7fqzcb8TmcQg8yPDpGY6dFelo3AMDfOkyUsA=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-pJEjRVvNqvq7Df2uy1kWjX59dk57/Pp6soX6IIP4fnA=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-0zMXV9sYDZ/iY7RpiZ+tLdg0swgaV7SG1UbD9tEKcls=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-Qf/UEO/IPhAw88Hs3/SD8NUmM6ATi8wNKec2BkYvHp8=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-OEDtoq305IGN4AeS6BithdH/IbjtOmVCpHMe99YuVJ8=";
  };
}
