{ lib, vscode-utils }:

with vscode-utils;

let

  buildVscodeLanguagePack = { language, version ? "1.76.2023030809", sha256 }:
    buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-language-pack-${language}";
        publisher = "MS-CEINTL";
        inherit version sha256;
      };
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
    sha256 = "19brasjwwgdskgwayclmsywf007i2d47vx7dwq6hq2bhx4rd6xfy";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    sha256 = "1s5x3w125fliimr0i218mars4xjl70hsz0ihxrjk97c66yzg3gw7";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    sha256 = "0ih8h3n5mcadclxxlrgajq7kprgj9fbklccc00r0z8vqnmlc0dw0";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    sha256 = "077n4mlx9qxqlp018wfi6hm3syhxsp2xzyih42kpsp71xi8j113r";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    sha256 = "04mdxspm8i1dra0qmim4n4qin050adm2zk9pcnn3z4qbf3yvvnf4";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    sha256 = "0f2bg5nm4sybwf84afvhc22yjp66rzdz4s1iaa31yxb4c1ij2vsr";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    sha256 = "1dspg6x7n9b89cirf63m2y0p6r2m197qzgvvavqfm7bv6cpskha0";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    sha256 = "1idiv9xqfqhz1y3pd4h3ayy3svccr4jhrm23nf9h80g38k74qayi";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    sha256 = "0g980sfa386by741sxxlapc2cjsbkfvldcc5kylxvf2drigyvka7";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    sha256 = "0sm3xxiv8lrln051yjq6s5jmpvkbphv1i90lrx472pwknmiwx74a";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    sha256 = "1k4y528im6sr8n4blh6k4xng4d534siaaflvnarizs3py9wa61d1";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    sha256 = "1yf59idj6g77sqkm46bdadklvbvb3ncxzd9mfm9y32h54fxffh6a";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    sha256 = "1dmn58fx8mpbn84zqyy09a1j67b5988gn7xjmfdk73bbd7hzbmji";
  };
}
