{ stdenv
, fetchurl
, unzip
, makeDesktopItem
, imagemagick
, SDL
, isStereo ? false
}:

with stdenv.lib;
let
  pname = "goattracker" + optionalString isStereo "-stereo";
  desktopItem = makeDesktopItem {
    type = "Application";
    name = pname;
    desktopName = "GoatTracker 2" + optionalString isStereo " Stereo";
    genericName = "Music Tracker";
    exec = if isStereo
      then "gt2stereo"
      else "goattrk2";
    icon = "goattracker";
    categories = "AudioVideo;AudioVideoEditing;";
    extraEntries = "Keywords=tracker;music;";
  };

in stdenv.mkDerivation rec {
  inherit pname;
  version = if isStereo
    then "2.76"  # stereo
    else "2.75"; # normal

  src = fetchurl {
    url = "mirror://sourceforge/goattracker2/GoatTracker_${version}${optionalString isStereo "_Stereo"}.zip";
    sha256 = if isStereo
      then "12cz3780x5k047jqdv69n6rjgbfiwv67z850kfl4i37lxja432l7"  # stereo
      else "1km97nl7qvk6qc5l5j69wncbm76hf86j47sgzgr968423g0bxxlk"; # normal
  };
  sourceRoot = (if isStereo then "gt2stereo/trunk" else "goattrk2") + "/src";

  nativeBuildInputs = [ unzip imagemagick ];
  buildInputs = [ SDL ];

  # PREFIX gets treated as BINDIR.
  makeFlags = [ "PREFIX=$(out)/bin/" ];

  # The zip contains some build artifacts.
  prePatch = "make clean";

  # The destination does not get created automatically.
  preBuild = "mkdir -p $out/bin";

  # Other files get installed during the build phase.
  installPhase = ''
    convert goattrk2.bmp goattracker.png
    install -Dm644 goattracker.png $out/share/icons/hicolor/32x32/apps/goattracker.png
    ${desktopItem.buildCommand}
  '';

  meta = {
    description = "A crossplatform music editor for creating Commodore 64 music. Uses reSID library by Dag Lem and supports alternatively HardSID & CatWeasel devices"
      + optionalString isStereo " - Stereo version";
    homepage = "https://cadaver.github.io/tools.html";
    downloadPage = "https://sourceforge.net/projects/goattracker2/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

