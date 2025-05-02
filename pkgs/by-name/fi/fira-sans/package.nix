{ lib
, stdenvNoCC
, fira-mono
}:

stdenvNoCC.mkDerivation {
  pname = "fira-sans";
  inherit (fira-mono) version src;

  installPhase = ''
    runHook preInstall

    install --mode=-x -Dt $out/share/fonts/opentype otf/FiraSans*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://mozilla.github.io/Fira/";
    description = "Sans-serif font for Firefox OS";
    longDescription = ''
      Fira Sans is a sans-serif font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS.  It is closely related to
      Spiekermann's FF Meta typeface.  Available in Two, Four, Eight,
      Hair, Thin, Ultra Light, Extra Light, Light, Book, Regular,
      Medium, Semi Bold, Bold, Extra Bold, Heavy weights with
      corresponding italic versions.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
