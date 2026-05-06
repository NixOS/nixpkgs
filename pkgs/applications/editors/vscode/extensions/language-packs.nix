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
      version ? "1.110.2026050117",
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
    hash = "sha256-XToqx+5HQuXIHLNMPK+lMkVFzd9MublV40e6SxVqCSY=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-t4S0FbwrcpL4M7zWjY+6GS6WFVuL8SoDP+2R+7CeX4g=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-ioXDbtJr66u9/woHhOLhw3mswAidghiUAbtSgXeSZc0=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-V5ZPpP6PxYbi9dIH/963uHtKvcMj8lGQumaWnKsoJuI=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-Z6bkJpppzcjYnstMR5K9takUFuuq4mGvCxgyJ6t1pgY=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-6akcldam+4f58nH748Tuohr2PN5Na69uXOk6U1W2t0Q=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-FlPLboMVHSh4C4YXl+efErT6bk+KAhWurBlHqEUz99A=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-ybgpI/74hwAXSush0uAVPwxAjBnypeMq7DF8S0117aU=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-ied18u8T9PG95XZaGLZxC8pyBe0vrZGqYuvNFpOGJuk=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-uAkiAiq0k5X2KBWcRvvsV1+MSk6IcBJOJ1/O9GYYUFQ=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-mkgCDjqhMkwdsikm2cE8df/k8MxXMC1bDhd7YatSDoE=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-wE4sYqTWohj6HWA9mb8/6S6CziZugzxEJ+nl4lgPbn0=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-Q5CAm1SOZBPHNTssw04pEZRVxWuECZfy00AR6nm2Kf0=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-FDbV6JLGqI7iTBCpJsDGVt/keGRuPUlzVfrhKodswTk=";
  };
}
