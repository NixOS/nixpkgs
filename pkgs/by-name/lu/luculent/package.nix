{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "luculent";
  version = "2.0.0";

  src = fetchurl {
    url = "http://www.eastfarthing.com/${pname}/${pname}.tar.xz";
    hash = "sha256-6NxLnTBnvHmTUTFa2wW0AuKPEbCqzaWQyiFVnF0sBqU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "luculent font";
    homepage = "http://www.eastfarthing.com/luculent/";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
