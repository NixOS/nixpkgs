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
      version ? "1.107.2025121009",
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
    hash = "sha256-vz5Lh308kbuBNnK3RS6MViUjZ2W5MrVdzmNaG3TaMEQ=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-HlU8fjo5W0ktKQeBU0j0fVpO7Xy50CuD5UBlyGBJnak=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-FjWCMUwvdYduYk89XCtKMBIBgLlW65prs5TJn2cT4u4=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-yVbKe1iNvZJEHBt5vgJJF1cezE2NpxyVN2RHEq+BSoc=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-6vepylJv/86N2xx6mziJ3Pxeor1ky0JNB9anELIuh7U=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-TW9ErKMCWuiuHX13kYjqq0aCaLnljstlGbuWHr6JOM0=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-rl9T381SdejJeZJIKEGbgEAPx1AXzBqE9NBp+gvgbB8=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-CJ9tlx+suMIK5GWQaUMHeZyZfdvAlwKs+dYMch0pXGE=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-+8lsp940Oc7TxcE0qdWcGdciLR5oaSGjS0KZpse8xCY=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-Fee1SU0QHOaYf+Meu+tdKHERIo0u3ux8VHD5dB7jJzE=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-grXYxIF3zta2q40L68sqDXRpbsrHHT3M4EebY7Eeu7w=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-tcmYoV9yWq9WqN9s9NIzYJqdNhBdEmvL8SFX7lgmbcc=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-iKIemw2vU+vZguHpzcCDCTglZpEsUBfcH2aRIit6f60=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-WekUzEzhHHcxPIvE487QQ9/ZC2RTeBfxinD6hT8lOuU=";
  };
}
