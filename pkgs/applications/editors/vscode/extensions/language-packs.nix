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
      version ? "1.110.2026031109",
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
    hash = "sha256-Iu9sB9KBpHdbuhYMTglwvZdGTBXBCfAGtDcrP+8zcdA=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-OUAOWkrLl7YlW4AK2c2WlHU5a7EnFZsE8pDfA3ywswQ=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-sSUDuOEtkCqEVfahW3yRE57pyPmFJzYpOD81TjWGE98=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-O+TbCqM8qnFp3IsdpiQ7OlMWKuNIyZrvDZAKMbYRXb4=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-qEXRsqI8jfuTCX2zMnDwfHAiszk2abiwzJ+a1dio3ss=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-w3p2IPadb6gx/oxwgwcMPQsQYJ3vcunWRHjOVhiJOrI=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-UzYXuzenpvEiS927Ku2p5GHm9JwUxwtFNL8iIM4cPkY=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-Eie5fZDKk8vbaZRbJuIwURIUbIjqio22M6261BYe9MI=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-AwlHuG/r4anTKXsTag1UULbgKmU6M5Ng4+5Bjo4chVo=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-Gpwr6lCxHu4DJ/U5Np8VT6IvBRLsnBNtG1cCV/bMeXw=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-fzNMlrlVAP4uas+ITR1CFIq3Pip1d/CGXg5qdgNbxV4=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-nP5NRddP55KdJgwj5eFDDeSX2SiSHnDaBwPoRHmmoFg=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-O4SwzcBMpeKYisxM2VwMFmtqcbyi9Boj0LTJE6PUw3I=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-zFH9cjyPLC2nmi3vh4siiwtLyJbfXEjbHDQFnkoa5A8=";
  };
}
