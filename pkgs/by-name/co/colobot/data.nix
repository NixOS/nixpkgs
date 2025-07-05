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

stdenv.mkDerivation (finalAttrs: {
  pname = "colobot-data";
  version = "0.2.2-alpha";

  src = fetchFromGitHub {
    owner = "colobot";
    repo = "colobot-data";
    tag = "colobot-gold-${finalAttrs.version}";
    hash = "sha256-Voxfc5iCFT7gyahaai5wLPi6fe7dWryYLjfNjfXpwWs=";
  };

  nativeBuildInputs = [
    cmake
    vorbis-tools
    xmlstarlet
    doxygen
    python3
  ];
  buildInputs = [ gettext ];

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

  meta = {
    homepage = "https://colobot.info/";
    description = "Game data for colobot";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ freezeboy ];
    platforms = lib.platforms.linux;
  };
})
