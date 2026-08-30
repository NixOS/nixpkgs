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
      version ? "1.129.2026071717",
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
    hash = "sha256-00C1nGfJSWIiHlR9ezynZo/4xw/NIcO3RO2xgCj0Nv0=";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    hash = "sha256-OHQV5KIYFkvOBpGgBnA+8FG9grKd7+qYgOBX+MDgiXI=";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    hash = "sha256-WFK66b38LTe7NKoFONzcYwUZ0V/ZfXoh6lb3zpwOUNw=";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    hash = "sha256-Ocv9CZ9o/MILdPABUwN0KeTPIhnxKjld/ENvvzRpSF4=";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    hash = "sha256-sWD7F41gtMDGe9nLz+lYY5cUHn2V25TMy5svXTCFmLE=";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    hash = "sha256-OQ2RF12MQQzMd3aAMx1/iPTkoiYv2KMMoC7gPErwCK8=";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    hash = "sha256-qmDJ1l23J0DWiPqzhkowYEcW5MuBePZzKNAsIl/D/Ks=";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    hash = "sha256-RqO+OO4wzEc3UQYoWPweXLYMKjNLgwobWzrulREbCmU=";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    hash = "sha256-g/vsx1OSwwxcIttYUn5OsqdIceqpXMjPX2SXaogdwmw=";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    hash = "sha256-zAlei2SxawTwDdK3SV0nQ7x99VRgsCg5nJ25w8gnIBc=";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    hash = "sha256-ojj+3NOv69MY/xMde3OKezJQLOT7iMqCe04uNAE59qo=";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    hash = "sha256-zSbGC6vY2wbWoXdgyvS5z+AOqss8V27h1Nt1uCt8B9c=";
  };
  # Polish
  vscode-language-pack-pl = buildVscodeLanguagePack {
    language = "pl";
    hash = "sha256-vQhv7Sl228hJ869HM5WQClZ4KHtzYxIhvMUTMpYDJO4=";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    hash = "sha256-KWko5Ce40gs89JRawgqILagr7Qhr5SiNvo60pKZtELo=";
  };
}
