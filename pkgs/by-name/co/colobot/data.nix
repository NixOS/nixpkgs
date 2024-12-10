{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gettext,
  vorbis-tools,
  xmlstarlet,
  doxygen,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "colobot-data";
  version = "0.2.0-alpha";

  src = fetchFromGitHub {
    owner = "colobot";
    repo = "colobot-data";
    rev = "colobot-gold-${version}";
    sha256 = "sha256-yzIbAzrGsDe6hO0GHF9gjnj7IE8B7+5LDbvjZi4Wtms=";
  };

  nativeBuildInputs = [
    cmake
    vorbis-tools
    xmlstarlet
    doxygen
    python3
  ];
  buildInputs = [ gettext ];

  enableParallelBuilding = false;
  # Build procedure requires the data folder
  patchPhase = ''
    cp -r $src localSrc
    chmod +w localSrc/help/bots/po
    find -type d -exec chmod +w {} \;
    for po in localSrc/help/{bots,cbot,object,generic,programs}/po/* localSrc/levels/*{/*/*,}/po/*; do
      rm $po
      touch $po
    done
    # skip music
    rm localSrc/music/CMakeLists.txt
    cd localSrc
  '';

  meta = with lib; {
    homepage = "https://colobot.info/";
    description = "Game data for colobot";
    license = licenses.gpl3;
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
  };
}
