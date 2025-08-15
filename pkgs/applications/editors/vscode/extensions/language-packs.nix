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
      version ? "1.103.2025080609",
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
    hash = "sha256-EN562YK/mAUpvwuNXL+reLMuh5EdY6TcVJbt7clSK2Q=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-gsYvAR3HvqzYzEQDUeJD7Wg4fpk+byUGz1IvQh6+oms=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-l0lBj1gGGrTqCsjLVamIejbhchIzb7SpZfKed+nT/nQ=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-I6IHTWorrK4QnN+RRHIi4cS/SlxerjbYLhJuJeWzJW4=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-Tba4zLqxFLdupIPah2059oA9ZQVzq7Z77pwFAH96CLY=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-hSHHAh59Kwgm/fG21EMAEHgBuDnin4+3IrCUWSjbGJ8=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-hKZzKPXExkw3FGjE33eHJy8CiIxkQdRreRDHonHdt9A=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-UFhdArcnxzCXr4Ha9B5WGdJ8fV+jqitJYgS7bFdo7qU=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-SOu9WXhSy2VOlCuhRlyU2vwrHKAqtacEHqv1jmfVOe0=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-AR+88WY5AhN2VCzuiFPR60K4KyO31nxlyI8g8Ya+278=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-oIdLJqu07BmyDhROvHt0pbsdITkmI+bMlWybuU9kwpU=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-5G3f4mdT29R4ics/ukxgBDZJ8FT0iCe9r4LPfgKjRjc=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-nhF2DDvPGjOLQid++XxvG3vSU5OSZ3gVrHdujGCsQjA=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-DpsMvjzXo56RYUPgsctwpdvd7gTiFQSGiZeqZcJZU4k=";
  };
}
