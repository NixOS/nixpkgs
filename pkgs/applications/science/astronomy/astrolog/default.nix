{ lib, stdenv, fetchzip, fetchurl, xorg
, withBigAtlas ? true
, withEphemeris ? true
, withMoonsEphemeris ? true
}:
stdenv.mkDerivation {
  pname = "astrolog";
  version = "7.70";

  src = fetchzip {
    url = "https://www.astrolog.org/ftp/ast77src.zip";
    hash = "sha256-rG7njEtnHwUDqWstj0bQxm2c9CbsOmWOCYs0FtiVoJE=";
    stripRoot = false;
  };

  patchPhase = ''
    sed -i "s:~/astrolog:$out/astrolog:g" astrolog.h
    substituteInPlace Makefile --replace cc "$CC" --replace strip "$STRIP"
  '';

  buildInputs = [ xorg.libX11 ];
  env.NIX_CFLAGS_COMPILE = "-Wno-format-security";

  installPhase =
  let
    ephemeris = fetchzip {
      url = "http://astrolog.org/ftp/ephem/astephem.zip";
      sha256 = "1mwvpvfk3lxjcc79zvwl4ypqzgqzipnc01cjldxrmx56xkc35zn7";
      stripRoot = false;
    };
    moonsEphemeris = fetchzip {
      url = "https://www.astrolog.org/ftp/ephem/moons/sepm.zip";
      sha256 = "0labcidm8mrwvww93nwpp5738m9ff9q48cqzbgd18xny1jf6f8xd";
      stripRoot = false;
    };
    atlas = fetchurl {
      url = "http://astrolog.org/ftp/atlas/atlasbig.as";
      sha256 = "001bmqyldsbk4bdliqfl4a9ydrh1ff13wccvfniwaxlmvkridx2q";
    };
  in ''
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

  meta = with lib; {
    maintainers = [ maintainers.kmein ];
    homepage = "https://astrolog.org/astrolog.htm";
    description = "Freeware astrology program";
    mainProgram = "astrolog";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
