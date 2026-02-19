{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nanum";
  version = "20200506";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/f/fonts-nanum/fonts-nanum_${version}.orig.tar.xz";
    hash = "sha256-FXgDdIGYFRJQo898sDrvhE5AjpyYhJ3YieGRhGqsrUs=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts

    runHook postInstall
  '';

  meta = {
    description = "Nanum Korean font set";
    homepage = "https://hangeul.naver.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ serge ];
    platforms = lib.platforms.all;
  };
}
