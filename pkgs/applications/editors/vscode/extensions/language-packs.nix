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
      version ? "1.98.2025031209",
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
          for lang in cs de es it ja ko pt-br qps-ploc ru tr zh-hans zh-hant; do
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
    hash = "sha256-ulFnHulIa1T+WdlXa000cYDY/SWGcA9W/uLZrP5l40Q=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-o9EwOKuFVqB1gJvCh4S5ArwQDN21a3zhLBsCpeztUhU=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-x20EJ6YfMT59bk8o8LYDqQgyOmI1NH/Jq2zjtrUHOt8=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-MerP4/WBKj/TauDnQcWv0YCFh9JA1ce0jHiFAvt5NdI=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-0Z4jSiP16EDFyHwQAgvFpMh5F8tCu74hUojXH5EK66o=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-CQtb7FJGR2JVznbEYVN76IywQopwZ6TzWjxE1as7WWE=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-LmBcWZlyAVvXoa5sZ4gpWBkBZD+5AKkFZqSs4zXkCwc=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-4tj4wTCOnC2KpHWN86EZl5KmNl2QLXb7Co1aYwRZ7uY=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-NmSSijvWckFiyyQBo+2Lv70YsqOYR/5kHP4iiqaQUZU=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-Q8jSCYzl/DXasi0n228Kd7Ru0z1Bb/ovTySAYCV42pg=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-PJPeTn+0g1s+L7t9d6A/hyrBEF0EE/QKshHa3vuQZxU=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-+M43EdHHsmw1pJopLi0nMIGwcxk6+LeVvZjkxnxUatI=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-2ERwup1z7wGVwoGfakV0oCADxXWfWbYxlkQ6iJYgXkc=";
  };
}
