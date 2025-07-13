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
      url = "https://www.cle.org.pk/Downloads/localization/fonts/NafeesNastaleeq/Nafees_Nastaleeq_v1.02.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    })

    (fetchurl {
      url = "https://www.cle.org.pk/Downloads/localization/fonts/NafeesRiqa/Nafees_Riqa_v1.0.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    })

    (fetchurl {
      url = "https://www.cle.org.pk/Downloads/localization/fonts/NafeesNaskh/Nafees_Naskh_v2.01.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    })

    (fetchurl {
      url = "https://www.cle.org.pk/Downloads/localization/fonts/NafeesTahreerNaskh/Nafees_Tahreer_Naskh_v1.0.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    })
    (fetchurl {
      url = "https://www.cle.org.pk/Downloads/localization/fonts/NafeesPakistaniNaskh/Nafees_Pakistani_Naskh_v2.01.zip";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
    license = "unknown";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bergey ];
  };
}
