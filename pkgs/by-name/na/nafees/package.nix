{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation {
  name = "nafees";

  srcs = [
    (fetchurl {
      url = "http://www.cle.org.pk/Downloads/localization/fonts/NafeesNastaleeq/Nafees_Nastaleeq_v1.02.zip";
      sha256 = "1h1k5d74pg2gs782910v7i9rz2633wdacy34ds7ybxbpjiz6pqix";
    })

    (fetchurl {
      url = "http://www.cle.org.pk/Downloads/localization/fonts/NafeesRiqa/Nafees_Riqa_v1.0.zip";
      sha256 = "1liismsyaj69y40vs9a9db4l95n25n8vnjnx7sbk70nxppwngd8i";
    })

    (fetchurl {
      url = "http://www.cle.org.pk/Downloads/localization/fonts/NafeesNaskh/Nafees_Naskh_v2.01.zip";
      sha256 = "1qbbj6w6bvrlymv7z6ld609yhp0l2f27z14180w5n8kzzl720vly";
    })

    (fetchurl {
      url = "http://www.cle.org.pk/Downloads/localization/fonts/NafeesTahreerNaskh/Nafees_Tahreer_Naskh_v1.0.zip";
      sha256 = "006l87drbi4zh52kpvn8wl9wbwm9srfn406rzsnf4gv0spzhqrxl";
    })
    (fetchurl {
      url = "http://www.cle.org.pk/Downloads/localization/fonts/NafeesPakistaniNaskh/Nafees_Pakistani_Naskh_v2.01.zip";
      sha256 = "1i5ip60gq1cgc9fc96kvlahdpia8dxdgcisglvbm2d212bz0s5nb";
    })
  ];

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
    # cp $riqa/*.ttf $out/share/fonts/truetype
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1wa0j65iz20ij37dazd1rjg8x625m6q1y8g5h7ia48pbc88sr01q";

  meta = {
    description = "OpenType Urdu font from the Center for Research in Urdu Language Processing";
    longDescription = ''
      The Nafees font family is developed according
      to calligraphic rules, following the style of Syed Nafees
      Al-Hussaini (Nafees Raqam) one of the finest calligraphers of
      Pakistan
    '';
    homepage = "http://www.cle.org.pk/software/localization.htm";

    # Used to be GPLv2.  The license distributed with the fonts looks
    # more like a modified BSD, but still contains the GPLv2 embedded
    # font exception, and some not-for-resale language.
    license = {
      fullName = "Nafees License Agreement";
      url = "https://www.cle.org.pk/software/license/Nafees_Pakistani_Naskh_License.html";
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bergey ];
  };
}
