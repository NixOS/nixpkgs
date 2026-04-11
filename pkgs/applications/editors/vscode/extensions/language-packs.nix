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
      version ? "1.110.2026040813",
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
    hash = "sha256-/34hQYL82oNV4AK+X9Qhc49y11U7QjBtQZkxX2DJCv0=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-igknYIMrlTf6dzPRCWeE2IQ8s7SsD4AFN/oPPISv5Vk=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-ovzQBQfdPQoVVgKl47qnucUQfhBBDCbbGwKlI86gR10=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-tn1irueWoqGidrxOv49IP0pdUPjk1mPvFppe2RHEs3E=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-3RMlWPzjHAYJsiulQOMqIZ0/u2hqxF+gZ9vVZVvPJWE=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-5ig0jME4lljWRKL3j64RobHW98IdjzrF/cZEEkpjMZo=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-gV/Z1br8I+fp+/4ALQQt75sNYJGK+opvUHpkYHwV2Xc=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-UilZzzy8DjhXQP6jrkndNBZFqUeX2zLVy05nOIDViKk=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-Z4a01eQD1bgQnlf0174DozkKqo5TeVR6J8sgnMPGmMg=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-CCqtlFQrlgRN8ds/pqMFP6S5Ks+ZpGu3iUfchSFX1mA=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-Yi2W8bdieyNxJfGy3XNafB5DX27VujSz8Dp8BMyBi1w=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-lKHTQryxzSgW7S3QVXHCr7DvFihD+vr2lOwiWk1klVQ=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-l2PBwwGS+HFswTF4gbS++AREmTMzzbiZtHzzvX900yc=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-9/SDMQ9v0zZq1fveWDx6TI/28o9NDzN0YI/tOcC7dks=";
  };
}
