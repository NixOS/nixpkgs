{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "soundfont-arachno";
  version = "1.0";

  # Many of the files in this archive have non-UTF-8 characters in their names,
  # which causes it to fail to unpack correctly on e.g. macOS/APFS when using
  # fetchzip. So instead, use fetchurl and extract the correct file directly.
  src = fetchurl {
    # Linked on http://www.arachnosoft.com/main/download.php?id=soundfont-sf2:
    url = "https://www.dropbox.com/s/2rnpya9ecb9m4jh/arachno-soundfont-${
      builtins.replaceStrings [ "." ] [ "" ] version
    }-sf2.zip";
    hash = "sha256-XAxXOr5sXho8zOul1SpCKdskKDYgyaPrH0AwGOKqIt8=";
  };
  dontUnpack = true;
  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/soundfonts
    unzip -p $src 'Arachno*.sf2' > $out/share/soundfonts/arachno.sf2
    runHook postInstall
  '';

  meta = {
    description = "General MIDI-compliant bank, aimed at enhancing the realism of your MIDI files and arrangements";
    homepage = "http://www.arachnosoft.com/main/soundfont.php";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mrtnvgr ];
  };
}
