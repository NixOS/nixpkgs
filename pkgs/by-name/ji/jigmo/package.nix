{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jigmo";
  version = "20230816";

  src = fetchzip {
    url = "https://kamichikoichi.github.io/jigmo/Jigmo-${version}.zip";
    hash = "sha256-wBec7IiUneqCEyY704Wi6F6WG0Z1KK7gBGcJhRjrRDc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Japanese Kanji font set which is the official successor to Hanazono Mincho";
    homepage = "https://kamichikoichi.github.io/jigmo/";
    license = licenses.cc0;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
