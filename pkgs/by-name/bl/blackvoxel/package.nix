{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  imagemagick,
  glew110,
  SDL_compat,
  nix-update-script,
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

  nativeBuildInputs = [ imagemagick ];

  buildInputs = [
    glew110
    SDL_compat
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace src/sc_Squirrel3/sq/Makefile --replace-fail " -m64" ""
    substituteInPlace src/sc_Squirrel3/sqstdlib/Makefile --replace-fail " -m64" ""
    substituteInPlace src/sc_Squirrel3/squirrel/Makefile --replace-fail " -m64" ""
  '';

  buildFlags = [ "BV_DATA_LOCATION_DIR=${placeholder "out"}/data" ];

  # data/gui/gametype_back.bmp isn't exactly the official icon but since
  # there is no official icon we use that one
  postBuild = ''
    convert gui/gametype_back.bmp blackvoxel.png
  '';

  installFlags = [
    "doinstall=true"
    "BV_DATA_INSTALL_DIR=${placeholder "out"}/data"
    "BV_BINARY_INSTALL_DIR=${placeholder "out"}/bin"
  ];

  postInstall = ''
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sci-Fi game with industry and automation";
    homepage = "https://www.blackvoxel.com";
    changelog = "https://github.com/Blackvoxel/Blackvoxel/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      # blackvoxel
      gpl3Plus
      # Squirrel
      mit
    ];
    maintainers = with lib.maintainers; [
      ethancedwards8
      marcin-serwin
    ];
    platforms = lib.platforms.linux;
  };
})
