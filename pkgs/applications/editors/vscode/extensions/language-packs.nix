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
      version ? "1.99.2025041609",
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
    hash = "sha256-c4p/wVQ9GIxEkF/82ZZpRKxem7IVMK3AzCI/YfZKF4U=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-ftAYkS5WRSqc+rB901J7X8IRE+XuqtIdRiBJfEKumQ8=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-37pDfoFi4QPOBP9vYPw/+zOXDOluuEojI6ZSYsiwv64=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-IASRtQag6wuNmKtes7L6i0coLluo6ryRW4lUEgQAiz4=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-H8UxMc1FKkfWOcITdwYrI6giD11Sk4YN2er+wnnFvBs=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-3yvzcJXdTIYbBNBaiuW92UYADSUeYPm3clSpSM3k71w=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-AiZYIoE2wdiRXdJVpOTnj0vFJH5UsYh8k5tf/0lNqVY=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-96bavTK4JNYk6tfDxnzujHA5V3a1/AL7PTnrNZsyiXU=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-NEkFv+I0TmK9wvfQ9Wc34Q0EnzrHuccQypIAVVYoofY=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-U1loNdDlYC8ahsy2xdeE/zBs/EhAo/DvoUI0rFFCA88=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-M02Q5HNCkT1Se+AuJXDNz3YfT9+kyuUTvosqor4bZ4k=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-ieYvmzK+5QmcwKSXK4X+NQQfd4OCf6IAKuepYByq4b8=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-DhhlFKICXWjC+c0POuO9upCD0DSzEJ6shkQoK/oTeM4=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-mpKx+rluYIuKmpvJVJH6uBPTk6OHBzCIpE7KpOskuEE=";
  };
}
