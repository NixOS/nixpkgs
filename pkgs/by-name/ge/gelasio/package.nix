{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "gelasio";
  version = "0-unstable-2025-06-30";

  src = fetchFromGitHub {
    owner = "SorkinType";
    repo = "Gelasio";
    rev = "4d7a1d2c662582095982a3851e50d7f1e034255b";
    hash = "sha256-GfJjpiTBayNfGULf3vqFOvQw9rqXIe8JJmF3fI9Km+Y=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp fonts/ttf/*.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Font which is metric-compatible with Microsoft's Georgia";
    longDescription = ''
      Gelasio is an original typeface which is metrics compatible with Microsoft's
      Georgia in its Regular, Bold, Italic and Bold Italic weights. Interpolated
      Medium, medium Italic, SemiBold and SemiBold Italic have now been added as well.
    '';
    homepage = "https://github.com/SorkinType/Gelasio";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ colemickens ];
  };
}
