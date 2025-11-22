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
      version ? "1.106.2025111209",
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
    hash = "sha256-oAXIOomKlysVHMIQJHrERJjHQKu6b+J3sWM8cerfiB0=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-YYjOzCMpwKv74Jwp3xz21SC5QzSPXdX2EYM8WBFl5uY=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-SBXixGKS5yyyFuN+kQHaPgYmdILnMXwZynu0k4Hwu5k=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-dX7ThgoS6Ua57BfZsQvREhWAqn/djJgEyKjKp1pn5dY=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-ED/nt2aG34MHqWthesZ1WhIDLNzg/AEhSv5vUIs8FS0=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-1JbxvexAPcjN7kWfGcI146QrgiEXXOVukHGQwyKPqEQ=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-sUU9UwJg+oGlmaooapzPsH8uPcgswsJ62G1ms8gGSAQ=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-M1udQ4ByEG4KKTnyD1E7fNa89ncR2s8vtxfIZ+PPBrA=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-d2oGEM7DbCzh2fVAgfGL960jbVPmGGku4Eb1Hf4BkhM=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-JkfYz881qwLD00UI085HejGH/TWymkAjDGQw9HkJq0s=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-OyN6/4JNaV3ONDBCV+Q7fKx3SHmAPUoxRpx/xOg8Ie8=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-1f06TgH/v/bb+rZTWp+Zocas0Qymr76J+Aise7S4JA8=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-0po0KAz4A45r339gvrpt8nrVO+heiNQ9fnH7PjWQgEg=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-gcujW0bs8OEvrhPgn9czwTcWDyEduDx/qnmKdIS+WXA=";
  };
}
