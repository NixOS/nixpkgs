{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "nunito-sans";
  version = "0-unstable-2023-03-31";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "NunitoSans";
    rev = "058bd7a2f33d6ad5ef1df985b3db403622016a8c";
    hash = "sha256-JfEu/QJNs4zvlFiHxevLWFva+I48Cv5C0NZM0o7k7oo=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/variable/*.ttf -t $out/share/fonts/truetype/NunitoSans/variable
    install -Dm644 fonts/ttf/*.ttf -t $out/share/fonts/truetype/NunitoSans/static

    runHook postInstall
  '';

  meta = {
    description = "Nunito is a well balanced sans serif typeface superfamily";
    longDescription = ''
      Nunito is a well balanced sans serif typeface superfamily, with 2 versions: The project began with Nunito, created by Vernon Adams as a rounded terminal sans serif for display typography. Jacques Le Bailly extended it to a full set of weights, and an accompanying regular non-rounded terminal version, Nunito Sans.

      In February 2023, Nunito Sans has been upgraded to a variable font with four axes: ascenders high, optical size, width and weight. Cyrillic has been added and the language support expanded.
    '';
    homepage = "https://fonts.google.com/specimen/Nunito+Sans";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.alyamanmas ];
  };
}
