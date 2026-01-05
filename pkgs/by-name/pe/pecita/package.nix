{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "pecita";
  version = "5.4";

  src = fetchurl {
    url = "http://pecita.eu/b/Pecita.otf";
    hash = "sha256-D9IZ+p4UFHUNt9me7D4vv0x6rMK9IaViKPliCEyX6t4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp -v $src $out/share/fonts/opentype/Pecita.otf

    runHook postInstall
  '';

  meta = {
    homepage = "https://pecita.eu/police-en.php";
    description = "Handwritten font with connected glyphs";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
}
