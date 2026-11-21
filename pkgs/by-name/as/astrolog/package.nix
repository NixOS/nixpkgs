{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  libx11,
  withBigAtlas ? true,
  withEphemeris ? true,
  withMoonsEphemeris ? true,
}:
stdenv.mkDerivation {
  pname = "astrolog";
  version = "8.00";

  src = fetchzip {
    url = "https://www.astrolog.org/ftp/ast80src.zip";
    hash = "sha256-3JA4piR4p5fqEn3aXt+j4FLaFfvdmDrlcUJ9ZMErCkA=";
    stripRoot = false;
  };

  patchPhase = ''
    sed -i "s:~/astrolog:$out/astrolog:g" astrolog.h
    substituteInPlace Makefile --replace cc "$CC" --replace strip "$STRIP"
  '';

  buildInputs = [ libx11 ];
  env.NIX_CFLAGS_COMPILE = "-Wno-format-security";

  installPhase =
    let
      ephemeris = fetchzip {
        url = "https://astrolog.org/ftp/ephem/astephem.zip";
        hash = "sha256-a3K/G8jTYA845nPJPeJSlmFKRMRCCxUNPdhESh7xGsM=";
        stripRoot = false;
      };
      moonsEphemeris = fetchzip {
        url = "https://www.astrolog.org/ftp/ephem/moons/sepm.zip";
        hash = "sha256-T3jEoW0ICzckzhJqvEQpcRrti79PW01KS2KIipCqRcw=";
        stripRoot = false;
      };
      atlas = fetchurl {
        url = "https://astrolog.org/ftp/atlas/atlasbig.as";
        hash = "sha256-P5M2sqJBom9J2dsquIsAOAMuQlh6EYwfETaIOGylAZ0=";
      };
    in
    ''
      mkdir -p $out/bin $out/astrolog
      cp *.as $out/astrolog
      install astrolog $out/bin
      ${lib.optionalString withBigAtlas "cp ${atlas} $out/astrolog/atlas.as"}
      ${lib.optionalString withEphemeris ''
        sed -i "/-Yi1/s#\".*\"#\"$out/ephemeris\"#" $out/astrolog/astrolog.as
        mkdir -p $out/ephemeris
        cp -r ${ephemeris}/*.se1 $out/ephemeris
      ''}
      ${lib.optionalString withMoonsEphemeris ''
        sed -i "/-Yi1/s#\".*\"#\"$out/ephemeris\"#" $out/astrolog/astrolog.as
        mkdir -p $out/ephemeris
        cp -r ${moonsEphemeris}/*.se1 $out/ephemeris
      ''}
    '';

  meta = {
    maintainers = with lib.maintainers; [ kmein ];
    homepage = "https://astrolog.org/astrolog.htm";
    description = "Freeware astrology program";
    mainProgram = "astrolog";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
