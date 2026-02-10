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
      version ? "1.108.2026012809",
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
    hash = "sha256-1+aWgvoXR/FqhnIn3OrLOC11jLXVWlO2yecpzr2Waww=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-t6jN3qok7B4/G/IjEXD6THO6c+8X+1gxny6W7qdh5mI=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-rZM/T1gbYrtcHNLW0itNdhKcRR938PwK5VBN0xLDIWg=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-PG3oOCjWRgh1ox6GAPRdZdf8QNP1JsJZznJnM+2Ihl0=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-RPpNet015xGnOszcKfehP9VxnfDAnQJ2A62rVtNBDew=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-pm1dCoK4YM8XBM/O6p42R4PYy5f95sLcECHJMAKFt9Q=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-cSM+2W5aCUA77kxgV7vyk7KAoSlkeT+y56ziIPjP9II=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-UfMMLKHi48Qhgm8PXFAfGFQFX6e8vQsl/RYqha42TOc=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-gneZF4CIEDy88juFZBiB9/o/rzTnu2du4aiZ+NH+XlE=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-ojh2KBEpTTJsAgM2RilGO58kkcWgaFf5nkiiZ4gYNtg=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-n55nI9gCxNpr6Pq70qJnmgp2rs0Gcblirg4SaeXAXtE=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-S6orhrfCaA4aeLhW3+rdaJb4X8h7IUjfBC9A+QgiQgk=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-YoNl44f2jEYXIhDKz+xU5fzt/JD6l86dtbqXFKOzHrk=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-onc+lk6itrWP5J17eVLIMcpG1gDM/rpTzKci8m2uBcY=";
  };
}
