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
      version ? "1.108.2026021109",
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
    hash = "sha256-wlNUPeU7gblFeQ0G6CE+lzC3xQW8Xy2DM0mpmy1K5dM=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-Nx+4ByeCnH3BxL41M6XcwlW5qgbUh9ex3Bu6xvy24UI=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-9747wTc4cdsEOZmy7JPNGL65vNG+bLEjN4CDMVbOphw=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-LKoDwonmsB9X50/DLTfh0rED/EvdWPbkP+i/n2pjfL4=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-CZhmpvW+EQW3E0PdRB7zz1XXQW+9vnzT99n7cagx7DE=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-QYgM9PRpHKB4SxAC5C92gkUsNXO9ua5GHqn7Cd9I8tM=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-X476P0tOH4VBgbW74/XnnsBdkAcq2co7rxzXD8O5Xtc=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-BoTVsv5KhZd+hZFdpe3RhU+VvpZu5Z2u3X1KPsEBd3U=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-/RaaiP32Ky9bbifWNDB3rCHu7G8rZS6jvEyJhnR+0A8=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-hHnrMUVmjXezk5k/q1jrd3Zp6NyetoeYnFQgAyEuX+8=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-JTkPbkwrH4Vxg6V9zTSame8WyjSli/LDVLCv4DY7zGM=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-rvM5SgcJujWztSREZulD4y5wZBm9e9CDseKozqtmNfM=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-M4XKkz1hgsjxsjqf7pQGYAB0rtJN9eKxM2WhDYGLssk=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-/zVq/03CcM7cgZ4/K7k4pYqkbc6bNuBnhMl38DRFulw=";
  };
}
