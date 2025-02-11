{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "soundfont-arachno";
  version = "1.0";

  src = fetchzip {
    # Linked on http://www.arachnosoft.com/main/download.php?id=soundfont-sf2:
    url = "https://www.dropbox.com/s/2rnpya9ecb9m4jh/arachno-soundfont-${
      builtins.replaceStrings [ "." ] [ "" ] version
    }-sf2.zip";
    hash = "sha256-Z5ETe0AKPCi4KlM2xOlNcyQn1xvCuor3S/tcrF+AwNQ=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 Arachno*.sf2 $out/share/soundfonts/arachno.sf2
    runHook postInstall
  '';

  meta = with lib; {
    description = "General MIDI-compliant bank, aimed at enhancing the realism of your MIDI files and arrangements";
    homepage = "http://www.arachnosoft.com/main/soundfont.php";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ mrtnvgr ];
  };
}
