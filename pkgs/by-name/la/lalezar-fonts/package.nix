{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "lalezar-fonts";
  version = "unstable-2017-02-28";

  src = fetchFromGitHub {
    owner = "BornaIz";
    repo = "Lalezar";
    rev = "238701c4241f207e92515f845a199be9131c1109";
    hash = "sha256-95z58ABTx53aREXRpj9xgclX9kuGiQiiKBwqwnF6f8g=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/lalezar-fonts
    cp -v $( find . -name '*.ttf') $out/share/fonts/lalezar-fonts

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/BornaIz/Lalezar";
    description = "Multi-script display typeface for popular culture";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
