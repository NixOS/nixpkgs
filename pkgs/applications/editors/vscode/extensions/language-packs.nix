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
      version ? "1.110.2026041514",
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
    hash = "sha256-k+wpnvLqp4blMWKuHf9IAyOZLExvekd4vYjzMiXQAhw=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-gKdW15gYsoAdBPJBYVvYMmgUW2fhBAZRLLKC9uPjmSk=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-8la5VVAq5+62/1biCeGqpA9ohvI7NEeH2M1Q4e4KvQI=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-XugtbAlrHH73AEAljJ6IdfXvnTWhxVFJJg09YzJbM5o=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-YO6uvr1QHvq8HTlPW2ebMADsfqd5acmNnXphDaDrBew=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-h9wvZX1/3raPIthq3L1iD2GyYcUON9IiqriAV6kJlSQ=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-TO4o3/+4HIElQA37O19u9Ul6VZ8IKCuMElEN9C8kUGo=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-RqO+OO4wzEc3UQYoWPweXLYMKjNLgwobWzrulREbCmU=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-QQRqctsXxEwGGTtc+o+CVzxw+Ec/ba4j3YXoZoalUQY=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-A/87U9aR4OPUIm6lDwQNHQFUv/wWsyh6rqFnG15VzN4=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-PUGEzmxWonHPl5i96dsFguWjKZPf/FVV2bzYBr63Xs8=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-Hs8LAvINGRO06CQEjSRee1ryT3X31jsy9lynghMzu7k=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-fJCNNoYLFhRIUbAFKiiAfc43V8aNKSu/ORNAzoqTTGw=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-zmnplZFsQQYuTp9TiBiuuPPcffmFHkIGcy8sn6dDt5M=";
  };
}
