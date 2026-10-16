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
      version ? "1.131.2026090407",
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
    hash = "sha256-4Ss5S6Qr26SzCT2V9MjRNaWfq25vvSHfiOJX1wYK4NA=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-SnE4avoYXX1u6u84vgvlQDk/yIPAb6NbnPVRELpjLcA=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-sLInJJHtytgQmyL2XsD0P5JwKYeftc7bTqTcdLlO5CE=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-EaBK5Dug09NfU0p7NviXZN57FbLRIvXJQO5EO6ItA+g=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-7hKXmbdzsufEGudgaX4d3Z7/qQSf0FLDEdJ0LvpedY0=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-C5fytxmwx5iL2v+PPgI8NCL+7/DbVjeav68MMf4X74M=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-FzZMOgoS0mRbMSvcOmcs4Yi9YJTMH4thWy3qkxUGnGQ=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-plmz6Q9Q23OQjqe45iHVMxLn2g51HsdK26gyduoZebo=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-bbfLl+kuBiDHYbD2KQhL9Ys+LYGMTtBczdt6Pm8bY9M=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-z4LYvyJ/h4Apr7bDh9AvSqWQpF5K0MiycsppxTPQD5E=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-wJsu9rEnM3XRjxnmi4w8E9GqgfBH2B2LbhYvA5V+T5E=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-5FhpCA4STYz0GBLlTNe7EJdbRtVQQ+UgVwTIMkJusUI=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-5NAA4+xT/omDGdVV+pI5Vyh+zaL6UyoSeLo7h8CgnwA=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-GlNEqOug+3iTk6eTsXKoQSr4lkQs5XaYisC7IyZGpyU=";
  };
}
