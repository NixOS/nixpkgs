{ lib, vscode-utils }:

with vscode-utils;

let

  buildVscodeLanguagePack = { language, version ? "1.75.2023021509", sha256 }:
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
    sha256 = "0d2cbgi238kdy934c64v5vpqj53ikdhckx27g99k2d5wxrk4q90g";
  };
  # Italian
  vscode-language-pack-it = buildVscodeLanguagePack {
    language = "it";
    sha256 = "1yf7cg9gnqqwaq47bhmramvw8p4sbsf3mvm2xyyhihd81k75bvgh";
  };
  # German
  vscode-language-pack-de = buildVscodeLanguagePack {
    language = "de";
    sha256 = "12vbm7nqj6srbl2ci705iphvvdyxpsl27kfdn0v8i8fd6rp3livn";
  };
  # Spanish
  vscode-language-pack-es = buildVscodeLanguagePack {
    language = "es";
    sha256 = "1kqyvp6591ngjwcia4by8awb48c09v3zbjnarklw8brf8wij6xac";
  };
  # Russian
  vscode-language-pack-ru = buildVscodeLanguagePack {
    language = "ru";
    sha256 = "0s47k3l1fdhrnbpbnd8v8v6qj08hjs821rygprl63v45x8zszjbi";
  };
  # Chinese (Simplified)
  vscode-language-pack-zh-hans = buildVscodeLanguagePack {
    language = "zh-hans";
    sha256 = "074ibsxhgmrri2z351fzx3wv2sr5kdqmd9i2gi2n6sl7xy866mv9";
  };
  # Chinese (Traditional)
  vscode-language-pack-zh-hant = buildVscodeLanguagePack {
    language = "zh-hant";
    sha256 = "17f4yrgnv629n8ha2p33mrmzja68giql4ww6xmn2nws0xg07jkx1";
  };
  # Japanese
  vscode-language-pack-ja = buildVscodeLanguagePack {
    language = "ja";
    version = "1.75.2023020809";
    sha256 = "1sz0mx8rzlis0y4iqlkvi60nnwapwzv3r8124is9br4zqjvqmdzc";
  };
  # Korean
  vscode-language-pack-ko = buildVscodeLanguagePack {
    language = "ko";
    sha256 = "09m81hrd412hsdxyhjrr3xmsa05grjh08f3j8jdhwc1a9zdfr6rq";
  };
  # Czech
  vscode-language-pack-cs = buildVscodeLanguagePack {
    language = "cs";
    sha256 = "1zfai72mlj6yvjnmvdfycd2x61b4ymbpalhrf895df8xqrp6gcwa";
  };
  # Portuguese (Brazil)
  vscode-language-pack-pt-br = buildVscodeLanguagePack {
    language = "pt-BR";
    sha256 = "0pbqysx7l659n7m0m4i7bvpj5ji2g8561ml32hd3l54w9khavjlw";
  };
  # Turkish
  vscode-language-pack-tr = buildVscodeLanguagePack {
    language = "tr";
    sha256 = "1cc06dv5fxfnrw41j41da7gjjy4786zfk8gzcy275ii4ay0nmw06";
  };
  # Pseudo Language
  vscode-language-pack-qps-ploc = buildVscodeLanguagePack {
    language = "qps-ploc";
    sha256 = "1igb0g9z07sbr6i9igvh5vwqca357q6kbvcnrm3bh633j5z2d45x";
  };
}
