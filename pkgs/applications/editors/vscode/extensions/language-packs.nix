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
      version ? "1.102.2025071609",
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
    hash = "sha256-AMxwVWeFsmHLcL3P4pDLYAPgMJeSIkkeyOLVBEBJBVA=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-6bS/hI9NtIFXYLxz09tiPow9GGKTR1XLLYOZ6iMULf8=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-IL3XJqQORYfP36azhBiAxBU3EjZKP4RkD9KisW+2QnY=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-HsxFiHf2HXKCMDXofkim1P0so5uje+Zb33LfNhVg0Kc=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-OM/dQJEr39ryGCikPKjyrudDEGyN9rGH/N3M/O5Eur4=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-1h7Jpqn/mWS3IgnZcl3tCzcXBzbr/E4fr4oAKT14jbA=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-dyWd0B8MgfKRgg/XAgadthTplXKa9G2XTy7VHL0WR0Q=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-GYVKj/YNwG94UlSoHzM7zCilpx2r7nVF+D6+uez5V6Q=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-xQv9WijTw88lfggPxSHiGjkGKaZsLma/xcMj3XSifIs=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-a98aUdI92EEcuL25kxEFj4jSq3Q9IzuwnxrG6GsaWak=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-catHEoorr2EAzuuOH/c4PSfmdBA1gsfyBS6FPmNU39c=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-VOkNCU2fcXbnq5RPEOk4BSFlyU2QhOabwL2LipVxrVg=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-SeBZbRKR3ThQovNtwHO7l9Z88BHFd9+C3Jh0JM/UoYA=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-UFzourvEW0nPwTtte3q5J91xNyQhWT3IqNI6IGAS9z8=";
  };
}
