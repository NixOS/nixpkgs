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
      version ? "1.105.2025100809",
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
    hash = "sha256-HFpkXUYz7//5KlKe1NjiT/KBFBar9H5ivpltqGOTHJo=";
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
    hash = "sha256-iO+1Lq/vXkMCGNnj9CovBhLPtbuJtGHSfQnjXypRBcw=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-HxTStM+g/XKJH1twNYMu/V7IM7vBlYF4mfcemV+oOQI=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-nCPu7pEXpM22M+2IMtuPgxzyEF3R6MPm2CVZAccPdAU=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-JKKqrwGn/EMDMot1cIgLpekUVQf4IY+snENeKoE5jYU=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-6OWcr/XnJsOvRFho+P5Z+ppuAC8d08I3s0YWnLhH874=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-VqlAaS679KF0ZKlzDT55FIu5GKyzU41y1ptX7t88UHc=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-yFtp+XK7Y2Fi/uYqsh88d3hCRcQJhJOLWvs2pQ05ddo=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-2zM8E832ioa6fqnWzPq+PA/eiEAo8FDNNH/4HJPZIcI=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-7ghSb/sQM64wfsRRtS+quAqJEvUdIXAcPCQKJbsDXKc=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-/joZpsIAY9Ut67wAbzNTraBgBgtjDAeRoq8PUbP3rSc=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-xERSh5N5Mbyc977ji0n91ra0RV9ZldJKBzc3IWYWYyo=";
  };
}
