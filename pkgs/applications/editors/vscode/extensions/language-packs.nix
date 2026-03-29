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
      version ? "1.110.2026031919",
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
    hash = "sha256-a8N3SX7lgfTMlBk70hOdKtgO4e9uyMziRaSp/QmkUQM=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-OyZ0rUTFg2Epb/adz2kFbStIeDoDyWj/fA3MC3QPLT4=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-Z7zIviuD9UcSK8Z0qlq7PnqYWmacUlrYu0lDTjbmS+g=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-fSJ5D7kQ5zMppUqVIAjBfQ2mNzBpiF1myFfqtk2QPSs=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-qEXRsqI8jfuTCX2zMnDwfHAiszk2abiwzJ+a1dio3ss=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-zwBfoB17agsVK/NLxZ8WaoM49emmLX2otPsba0pjg7w=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-P9cKdfuGAOq/Ow3ojKaUiEfChEED4eXbSaFtqp5yWWs=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-+SXH6Uy9CIrG4Ff+Wzq9+N+SKEGcTtXbcpyW5OA2sGA=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-7gV6rK8RC1LDMu6Rvo84ScmJJcc/BfgQl5dVE/dyWis=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-NvXwyaDDkAO22Hb7octXswkUP55zo3UgNtoLEQL1AQE=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-E9m4ATCtFm+Q+hHe9Yd++a1cuqjj3eF8H632HRsdjAc=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-YXXpXftw86/0vRPr9s4kOuf4EMykhgy0SDInNVgcr+c=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-mQ/Aya728qX/d5RNrv4IQrBu3IPh50HeC1Bn292/QYg=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-//+9p7P8CBVmAL6vcn1LzlAZBcrOlahjJvQhLeOQ1UU=";
  };
}
