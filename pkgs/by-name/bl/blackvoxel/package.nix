{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  imagemagick,
  glew110,
  SDL_compat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blackvoxel";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "Blackvoxel";
    repo = "Blackvoxel";
    tag = finalAttrs.version;
    hash = "sha256-Uj3TfxAsLddsPiWDcLKjpduqvgVjnESZM4YPHT90YYY=";
  };

  patches = [ ./remove-m64.patch ];

  enableParallelBuilding = true;

  buildFlags = [ "BV_DATA_LOCATION_DIR=$(out)/data" ];

  nativeBuildInputs = [ imagemagick ];

  buildInputs = [
    glew110
    SDL_compat
  ];

  installFlags = [
    "doinstall=true BV_DATA_INSTALL_DIR=$(out)/data BV_BINARY_INSTALL_DIR=$(out)/bin"
  ];

  # data/gui/gametype_back.bmp isn't exactly the official icon but since
  # there is no official icon we use that one
  postInstall = ''
    convert gui/gametype_back.bmp blackvoxel.png
    install -Dm644 blackvoxel.png $out/share/icons/hicolor/1024x1024/apps/blackvoxel.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "blackvoxel";
      desktopName = "Blackvoxel";
      exec = "blackvoxel";
      icon = "blackvoxel";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "A Sci-Fi game with industry and automation";
    homepage = "https://www.blackvoxel.com";
    changelog = "https://github.com/Blackvoxel/Blackvoxel/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.linux;
  };
})
