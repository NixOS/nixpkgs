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
      version ? "1.108.2026012109",
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
    hash = "sha256-cjfbZ5tdUhwSsU5HcfdFZP1pgSz9+FukfPVAdNdrwdY=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-YD1jTB9VzWF51QaFPRsEBC1pMkgrs2cl0HFA/PFz3ro=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-hIw0nFdYgcyOuJW8k7HRS0sKc0Gsuh7YWyLwQ3Z1FkU=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-1M15tY5WDSNGccy2O8SUxy+TYBSsxlE7xj+AtUChnZw=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-aHbMdaj9JSFVkMBp2ab7Clk3gZGL/kXpVo+fSuV3bk0=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-KLzq9gECFwoRgNRtoNnvo4phhJc4VsSJwnBzwaYLxTE=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-H4RMro40VfQB96Aol3k2eUlJqIZrSGAgFB7my56ionQ=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-adNk6Q/AmsLQ6V3H9mnpsmOjwITV3MvO31tLxfhFVGA=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-dZrrX7GobMfo3ut9p6CXouq4UtcwWZ1HmPWVCytgiHk=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-uk35vNOf02/re35HHhf+8MXQOqZJPOjjoEcN/JNd8To=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-oY347FL+h9wmTuVyZA6/xcNK9NXx9rs6ytE/aygpjK0=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-dJ0iZAQRF0n3LhQptT8qu+JQW2RfOrVprA7tZDpuS20=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-pH8y3H4vTv/xFgGMGPN/zKfhPya1uoUwDj0uwE/ClDQ=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-kBbFSsYWETitpDFonu/bXvCibuCQTYPSPdK1C4SNqvs=";
  };
}
