{
  stdenv,
  lib,
  fetchurl,
}:
let
  # Latest commit touching the rubik tree
  commit = "054aa9d546cd6308f8ff7139b332490e0967aebe";
in
stdenv.mkDerivation {
  pname = "rubik";
  version = "2.200";

  srcs = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-Black.ttf";
      sha256 = "0h4mxqz0b5as7g964bv98aanaghp4wgs2g5wnf7apxnd2fng14dn";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-BlackItalic.ttf";
      sha256 = "0x8j3fwavkf1jf7s97ncvs0jk463v1fyajcxqxvv7lpk55sjnbpy";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-Bold.ttf";
      sha256 = "0prjqdbdpnhwr66gjw9mc1590gmjl7fir8wnanzch6arvngmxaj9";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-BoldItalic.ttf";
      sha256 = "1zyl55fkjr61k6yfvgi0cr2iz4s0kkv3mkjpdmpla9jnk10rd8lm";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-ExtraBold.ttf";
      sha256 = "0vi01lc2dadgmw5z26nkfzn7vl3lsd0flhqqfp40nn8jvpdkb2mq";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-ExtraBoldItalic.ttf";
      sha256 = "0ldcszzzrc44gldflman7kcfk38x77grjb3zjvxjvgn875ggwabk";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-Italic.ttf";
      sha256 = "09x7fh6ad4w6027410vhkvisgy8vqm2mzdsc19z3szlrxi0gl0rx";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-Light.ttf";
      sha256 = "19a6k0pprcra6nxk3l0k6wkg9g0qn5h1v71rw2m8im64kyjx4qpf";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-LightItalic.ttf";
      sha256 = "0r9hbh9xnbp0584vjiiq72583j1ai3dw93gfy823c736y6bk0j2m";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-Medium.ttf";
      sha256 = "01nky9la4qjd80dy200j8l7zl0r2h9zw90k7aghzlb5abk4i3zvf";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-MediumItalic.ttf";
      sha256 = "1i81x9h2cr65bj85z5b2mki59532nvlbh92wb84zfhfdz97s30cq";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-Regular.ttf";
      sha256 = "1vk4n6yc4x1vlwfrp26jhagyl5l86jwa4lalccc320crrwqfc521";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-SemiBold.ttf";
      sha256 = "0blmy1ywsf9hr1a66cl12bjn32i072w6ncvsir0s5smm2c0gksvb";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/googlefonts/rubik/${commit}/fonts/ttf/Rubik-SemiBoldItalic.ttf";
      sha256 = "1sj22d3jrlxl6ka0naf5nby3k0i7pzadk5b8xgdhcslwijwiib3y";
    })
  ];

  sourceRoot = ".";

  unpackCmd = ''
    ttfName=$(basename $(stripHash $curSrc))
    cp $curSrc ./$ttfName
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -a *.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    homepage = "https://fonts.google.com/specimen/Rubik";
    description = "Rubik Font - is a 5 weight Roman + Italic family";
    longDescription = ''
      The Rubik Fonts project was initiated as part of the Chrome CubeLab
      project.

      Rubik is a 5 weight Roman + Italic family.

      Rubik supports the Latin, Cyrillic and Hebrew scripts. The Latin and Cyrillic
      were designed by Philipp Hubert and Sebastian Fischer at Hubert Fischer.

      The Hebrew was initially designed by Philipp and Sebastian, and then revised by
      type designer and Hebrew native reader Meir Sadan to adjust proportions,
      spacing and other design details.

      Cyrillic was initially designed by Philipp and Sebastian, and then revised and
      expanded by Cyreal Fonts Team (Alexei Vanyashin and Nikita Kanarev). Existing
      glyphs were improved, and glyph set was expanded to GF Cyrillic Plus.
    '';
    platforms = platforms.all;
  };
}
