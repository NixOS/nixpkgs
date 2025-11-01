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
      version ? "1.105.2025101509",
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
    hash = "sha256-dbiF9VXgC+qPBvzE5ScXcqJi/q3uM9q40P8QeINuGaE=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-gPEjTSk+4Q+ajps1ddG9y7ImLZyZHUTBjESo1DsrvNM=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-ry9GZvXhkOy4CQjr0arcecOFrCQfW27E+tD+VTQX7Yk=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-sNWm30LNhCz1V7F6aCPcMIuhIFhQEACW+mbZ4aNTGM4=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-9sA5F6NTceArpweL5UjgnkxPRB40fE6my4R2HFh4xYM=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-pKMfsmGezPvPg16wF5sJYQ7fwGpd/ZBNOaj/hkbp0HA=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-pfKeLHUFfdUsWCTTr6hP3UKdWcTWadAQ94J+2tp73MA=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-8qFibM/Gk9MoEimDQ5tL1gqI5jckb8+ipTVeb1G+6R8=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-Ec4yLH9GPPLVDvHFn8c6bpW30uWzI13lJlPnw12Bvy8=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-GF8kS9K2OAr39g7154ZpQvagnSUp/D0d5rqxDfaLEro=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-WGeEtxkWKFdZTIOPo2R13PNY0almlncexh+eVOg5PLQ=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-MGAvRKsiZQCKR0OfkaRkXyYCX3AMOmuVUyXvrDTTxcA=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-uQiRC4+wrnQkow0RHUJFNtGJ4pTby9JCydd8g89sNvM=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-cEYWi/XQoeV3vgJTC8SOCgClgyhQXDEcq97Y1UR3FFE=";
  };
}
