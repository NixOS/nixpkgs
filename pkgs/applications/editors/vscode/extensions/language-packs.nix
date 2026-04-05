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
      version ? "1.110.2026033112",
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
    hash = "sha256-ctn6bY2zJVz6XfhI37NOdf12RiKsS/Pa2IYFBMD06fs=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-ZZgTzQa0oTS7HFzYuJXncG97tPUovKr8BEh4ZgGwmWY=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-8qCjGIArVSfy/kwv00aLPniBREVW+cNAUbged10VQQs=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-9F4JEp0qVu1rsrJ01QMuhZPgMxybH/J5ENh2riDAe2c=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-1xRKJLuKjxYQ2D20K9QaQQQjmd8oHFmWVIe0OdeEfG8=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-VxM+Jjch/hVO80boUCU1iYkYoToTtUewHcIuJhQGkZA=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-ADR/ouefp5HnBwmGV0UBNAklgHg5mXNcBfX+VbJed74=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-hSilIspgNnJ05qgZk7uWvr8y4BAAPK/82j+dwshsGVc=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-A2gGsrno76caJvZguMsjE2xa6AzOfCz1Ge3fbh7yZWw=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-t70KwNkxiXFSw0NdiOGH6tjmeRP/RYinK/YxwLGfSw8=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-wOjewAGd1BCkrOQuhcWRbMm7YsRJGjac2+w5+fjWhBM=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-X7A8MWlBzijd+1Z6POBSRef5BgeI9qfSy576dx3yfII=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-bJc428MT8HyEUltmCFZEliSSPOE5TpHsaVKL1qukbVk=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-XVT+ssMh4SD+O93oDYbkLh4b8VPYA/9HOAKQURrLUuQ=";
  };
}
