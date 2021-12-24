{ lib, stdenv, fetchzip, fetchurl, xorg, gnused }:
stdenv.mkDerivation rec {
  pname = "astrolog";
  version = "7.30";

  src = fetchzip {
    url = "http://www.astrolog.org/ftp/ast73src.zip";
    sha256 = "0nry4gxwy5aa99zzr8dlb6babpachsc3jjyk0vw82c7x3clbhl7l";
    stripRoot = false;
  };

  patchPhase = ''
    ${gnused}/bin/sed -i "s:~/astrolog:$out/astrolog:g" astrolog.h
  '';

  buildInputs = [ xorg.libX11 ];
  NIX_CFLAGS_COMPILE = "-Wno-format-security";

  installPhase =
  let
    ephemeris = fetchzip {
      url = "http://astrolog.org/ftp/ephem/astephem.zip";
      sha256 = "1mwvpvfk3lxjcc79zvwl4ypqzgqzipnc01cjldxrmx56xkc35zn7";
      stripRoot = false;
    };
    atlas = fetchurl {
      url = "http://astrolog.org/ftp/atlas/atlasbig.as";
      sha256 = "1k8cy8gpcvkwkhyz248qhvrv5xiwp1n1s3b7rlz86krh7vzz01mp";
    };
  in ''
    mkdir -p $out/bin $out/astrolog
    cp -r ${ephemeris}/*.se1 $out/astrolog
    cp *.as $out/astrolog
    install astrolog $out/bin
  '';

  meta = with lib; {
    maintainers = [ maintainers.kmein ];
    homepage = "https://astrolog.org/astrolog.htm";
    description = "Freeware astrology program";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
