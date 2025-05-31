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
      version ? "1.100.2025051409",
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
    hash = "sha256-W0yM1vg+g7JbCoPmyzx3xSDvq1RoQq2lc6BkDtOkF3M=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-Lg6XS3VOzfIYTVCfE7wxzhXLFLug5hcTMrxp8BBKzk4=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-rgAKQd5gztaVQnqAHOY9BjPhM6CZ1NKkqI+oveJRo0E=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-5XEqcAxBlKGSmet12M1EAa7TiEzN5XyAaa9Tc/3smUM=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-EnzMlQoW9zqJHXwpCcYUu/vN+SHIoluVpij8lF44RJg=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-2oKthoWgXGsWsVco2bjkOyOEE5A4Tzhr+8n525Vkujk=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-oh3EuyFzWNf+JfALlIqauUIpuDEbU9Gr2Q+/0fkCguw=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-KRDS9q8jF9pHd8WiUxXUY6LLRUD95uVNWc78RA9rHo4=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-eF4M59rQG+8sz5h4zL766D/rgbcXSep/C3GdJwwRx10=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-dDWWlEkU4pX9AdBOnCI/VPACXI1xq7EjeUjn7zgr8vU=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-PZR9SOHXHmyiqbaTBETDUTZkjuk2XvF5MiH/laNMCLs=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-AKO04+S9wHap7yhvCyWMT6QT7zC0Rb8XRZvrg9ROjV4=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-VR7WrI4lnr3hN2GoS/ZxAZ3kEHdd+S0ZmLfOhHHkYWM=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-nWqw3Og0VMyDM7YgUX4xrd4dgXBDXUdk4AWqaapu3EA=";
  };
}
