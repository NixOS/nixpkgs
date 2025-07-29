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
      version ? "1.101.2025061109",
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
    hash = "sha256-DeloielNVsZk+1/rGlyfT49Hst+Xh/jk7BYvqNwMQuU=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-tc5G3O6KYP9+CI7t+B2jP9saKSbjoK7jceqrAT1lbZ8=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-5fLQkZj3U175NUY2uMwrpUg3KWSb+FYV69XT995tgko=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-OSpFOZc33jfcHWYiskqj5TIHjicdSAotXLeM9YnVycs=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-aqpBo19NvDYFWP1a6HnNvwuS6iEUhkn4lTihqy2EQqc=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-mykSRH3v7uW1iu4RmNf7SnL9q1ZPLkRZwY3sv5IfNt0=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-4AXpiJfFd4PpMR89IQWTnzeU+n3ROwmM1waI+h0odro=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-TGDBrATWlIDiCyOqxuGL5IHRObLRkEpwX8yo1HnvEvE=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-QKnA/5/J8nwnc91BEwAxOCHHlSG8nYyDGdiwAf9A4kM=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-XXQ5zXPZA9l/7QJVTtMZB7kLsM5/92anG+Mvpxq81RE=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-KYRt6KXkVthDXOZ2TLNJJFjDPvpknxRSi3Fo/T37KoA=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-4qCRDHTQD1jZ/pugAfSDdWeYU0GpM9PvRWXYNcncSUA=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-Cg+VpwX78HmyOHB9OGPPjSmJFHAZ4HpQ+HceFJw/FgE=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-Z2qrwgziEupCEqHVGyY1WnZO3ZGM1LVDeSxmVgkEd3o=";
  };
}
