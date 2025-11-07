{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  version = "16.0.3";
in

stdenvNoCC.mkDerivation {
  pname = "babelstone-han";
  inherit version;

  src = fetchzip {
    url = "https://babelstone.co.uk/Fonts/Download/BabelStoneHan-${version}.zip";
    hash = "sha256-HmmRJLs51hoHoKQYdjbiivnJl+RhcBwzkng+5PoqX10=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = "https://www.babelstone.co.uk/Fonts/Han.html";

    license = licenses.arphicpl;
    platforms = platforms.all;
    maintainers = with maintainers; [ emily ];
  };
}
