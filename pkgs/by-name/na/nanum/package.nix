{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nanum";
  version = "20200506";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/f/fonts-${pname}/fonts-${pname}_${version}.orig.tar.xz";
    hash = "sha256-FXgDdIGYFRJQo898sDrvhE5AjpyYhJ3YieGRhGqsrUs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts

    runHook postInstall
  '';

  meta = with lib; {
    description = "Nanum Korean font set";
    homepage = "https://hangeul.naver.com/font";
    license = licenses.ofl;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
