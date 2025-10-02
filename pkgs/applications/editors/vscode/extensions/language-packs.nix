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
      version ? "1.104.2025091009",
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
    hash = "sha256-7/TiCJ+PhrUpCLznMpxN10GpCObi4gclYz87vOsU2yI=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-94b/U8yLMlomLx/zi9L/2yOZTb51OIqRgT1Z/xADzG0=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-jUDGqsXZpHeKr+xgSwNYWKJTKs/3axV7o8iv7xlxP9w=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-hXOdM867rympTOJJh3v8y6B6FIez3+jhQa4kqL2p+98=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-Qt4V5ro1YvZkSkk2mxB/HLXsI3ewmmKor2ZxsMDAHRg=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-IBXnZNAorbFVu68UOwaGyVBNyPTILYgEZBy6k/EUNjA=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-iy3+HNkRFwJps/hqQMUjQfWxULewhF+sV1qg8BrMmQo=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-wZgMj8mmg8lIxX3JCi2fwS0l3/tSrOWuQpuTsW+J4wg=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-5GL95M9y60PjgNL7x/9JthV/g6+okoxT0uwmf/qPvqQ=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-PzhBxDl2X1LStXMHgqMPzl9v7XJ9VuL/8sCsdJ4mFfA=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-a8eGCArxLbMdQjpRBtcZJ8xlp9+Mbabiy6/v3/HANTQ=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-ZE9RXpV+k/7KcKlpE8AwW+3y2tupARhXTnucKfM304I=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-V6E5BsIRIPkZhq3g7F65/ml02HibeZyIs17R4TtJQU0=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-Tzqd6BJDGSxtxbZodWvBS64FIvxOmP5SaB+iAl3kU5w=";
  };
}
