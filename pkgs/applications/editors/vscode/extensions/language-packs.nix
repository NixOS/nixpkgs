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
      version ? "1.131.2026082318",
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
    hash = "sha256-hRVxiSUYuNZpnrcGNbPd/Egvq6843zS/SU1TK1tc9OQ=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-BP2XKRojsbtrx04+k9aOVhOpxxxmxcLUXJxbWxa1ogg=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-/2p2KKiWs1CmvE5OHmg5KAx74NBKVkf0bpmxZp3+AO8=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-vfBWmA1tHARNBKg85/A6mISPk4dijxL/+BVbP5oEE64=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-egbjXRNSWP7XzZR7VG2BI3ZN+fUw611LV7T8sFrsraw=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-rTBMyfbaIoZyTLWQjwN+6KkaAmSjmp9OdSsaDuHoAKk=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-P3kDcPK2860gYgd4sYZpb7zSpFFSRLRrSYmZg4fHhew=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-uqL5MP74icxDMb8M76bDYirZj3Kpl1sQ4aFOarivwo8=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-QjUomQA6bOdy2WY/DJ/p0R3TBg7OD47qocUF4U+7MYE=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-zAlei2SxawTwDdK3SV0nQ7x99VRgsCg5nJ25w8gnIBc=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-zl87BxVAHkGYxyagAWJ9XlMvKCXL1hq+jU/npwhhoss=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-dfAv6jkKCYN7sQSAoIOMXsQbTWg/xjiJ/XSQKaAhFhI=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-fosL9XQXpAHrOIOWEvvIUdeya7qZit0H04VDcDc/evs=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-iG/HXGktg18pHA/AMleOUpn+QzrRmtx+JhR+y0BwVJk=";
  };
}
