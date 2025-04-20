{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  libpng,
  glew,
  gettext,
  libsndfile,
  libvorbis,
  libogg,
  physfs,
  openal,
  xmlstarlet,
  doxygen,
  python3,
  callPackage,
}:

let
  colobot-data = callPackage ./data.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "colobot";
  # Maybe require an update to package colobot-data as well
  # in file data.nix next to this one
  version = "0.2.1-alpha";

  src = fetchFromGitHub {
    owner = "colobot";
    repo = "colobot";
    tag = "colobot-gold-${finalAttrs.version}";
    hash = "sha256-3iea2+5xCT0//NAjMHrynZKSoiOSgLTNMUQkRhXuXg8=";
  };

  nativeBuildInputs = [
    cmake
    xmlstarlet
    doxygen
    python3
  ];
  buildInputs = [
    boost
    SDL2
    SDL2_image
    SDL2_ttf
    libpng
    glew
    gettext
    libsndfile
    libvorbis
    libogg
    physfs
    openal
  ];

  enableParallelBuilding = false;

  # The binary ends in games directory
  postInstall = ''
    mv $out/games $out/bin
    for contents in ${colobot-data}/share/games/colobot/*; do
      ln -s $contents $out/share/games/colobot
    done
  '';

  meta = {
    homepage = "https://colobot.info/";
    description = "Colobot: Gold Edition is a real-time strategy game, where you can program your bots";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ freezeboy ];
    platforms = lib.platforms.linux;
  };
})
