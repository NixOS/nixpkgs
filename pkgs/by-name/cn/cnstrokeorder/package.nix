{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cnstrokeorder";
  version = "0.0.4.7";

  src = fetchurl {
    url = "http://rtega.be/chmn/CNstrokeorder-${version}.ttf";
    hash = "sha256-YYtOcUvt1V0DwAs/vf9KltcmYCFJNirvwjGyOK4JpIY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/fonts/truetype/CNstrokeorder-${version}.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Chinese font that shows stroke order for HSK 1-4";
    homepage = "http://rtega.be/chmn/index.php?subpage=68";
    license = [ licenses.arphicpl ];
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.all;
  };
}
