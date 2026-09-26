{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "nunito";
  version = "0-unstable-2025-02-26";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nunito";
    rev = "8c6a9bb9732545b9ed53f29ec5e1ab0ff53c4e6f";
    hash = "sha256-m276Gnkwpd+MjHo4mPU1RBcTs34puao7Wi+OOEuTuI0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/variable/*.ttf -t $out/share/fonts/truetype/Nunito

    runHook postInstall
  '';

  meta = {
    description = "Nunito is a well balanced sans serif typeface superfamily";
    longDescription = ''
      Nunito is a well balanced sans serif typeface superfamily, with 2 versions: The project began with Nunito, created by Vernon Adams as a rounded terminal sans serif for display typography. Jacques Le Bailly extended it to a full set of weights, and an accompanying regular non-rounded terminal version, Nunito Sans.
    '';
    homepage = "https://fonts.google.com/specimen/Nunito";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.alyamanmas ];
  };
}
