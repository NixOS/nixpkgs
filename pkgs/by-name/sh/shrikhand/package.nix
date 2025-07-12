{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "shrikhand";
  version = "unstable-2016-03-03";

  src = fetchurl {
    url = "https://github.com/jonpinhorn/shrikhand/raw/c11c9b0720fba977fad7cb4f339ebacdba1d1394/build/Shrikhand-Regular.ttf";
    hash = "sha256-wHP1Bwu5Yw3a+RwDOHrmthsnuvwyCV4l6ma5EjA6EMA=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D -m644 $src $out/share/fonts/truetype/Shrikhand-Regular.ttf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://jonpinhorn.github.io/shrikhand/";
    description = "Vibrant and playful typeface for both Latin and Gujarati writing systems";
    maintainers = with maintainers; [ sternenseemann ];
    platforms = platforms.all;
    license = licenses.ofl;
  };
}
