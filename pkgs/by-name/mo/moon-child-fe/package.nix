{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sdl3,
  zlib,
  pkg-config,
  sdl_gamecontrollerdb,
  copyDesktopItems,
  makeDesktopItem,
  iconConvTools,
}:
let
  plMpegSrc = fetchFromGitHub {
    owner = "phoboslab";
    repo = "pl_mpeg";
    rev = "c871f2be022ece7ef4f64230b4fb8e1fb9eb6023";
    hash = "sha256-Mr+hid5RRQ2Yh6UcNDFFbbHMrGGVju0o20KIAEvzEg8=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "moon-child-fe";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "MorsGames";
    repo = "MoonChildFE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SqoCSAFkQKcEbwDwHqicYXnQ8/HC523c+ePQFB+6rus=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeFeature "MOONCHILD_RENDERER_BACKEND" "SDL3")
    (lib.cmakeBool "MOONCHILD_VENDORED_SDL3" false)
    (lib.cmakeBool "MOONCHILD_VENDORED_ZLIB" false)
    (lib.cmakeBool "MOONCHILD_VENDORED_GAMECONTROLLERDB" false)
    (lib.cmakeBool "MOONCHILD_VENDORED_PL_MPEG" false)
  ];

  env = {
    MOONCHILD_PL_MPEG_PATH = plMpegSrc;
    MOONCHILD_GAMECONTROLLERDB_PATH = "${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
    iconConvTools
  ];

  buildInputs = [
    sdl3
    zlib
    sdl_gamecontrollerdb
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/icons/hicolor/256x256/apps/

    cd /build/source
    mv ./Bin/Release $out/share/MoonChildFE
    icoFileToHiColorTheme game.ico MoonChildFE $out

    ln -s $out/share/MoonChildFE/MoonChildFE $out/bin/MoonChildFE

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "MoonChildFE";
      desktopName = "Moon Child - Friend Edition";
      exec = "MoonChildFE";
      icon = "MoonChildFE";
      comment = finalAttrs.meta.description;
      startupWMClass = "MoonChildFE";
      categories = [
        "Game"
      ];
    })
  ];

  meta = {
    changelog = "https://github.com/MorsGames/MoonChildFE/releases/tag/v${finalAttrs.version}";
    description = "Modern source port of the 1997 Windows 95 classic, Moon Child";
    homepage = "https://github.com/MorsGames/MoonChildFE";
    license = with lib.licenses; [
      # Code
      mit
      # Assets
      cc-by-nc-40
    ];
    mainProgram = "MoonChildFE";
    maintainers = [ lib.maintainers.pyrox0 ];
    platforms = lib.platforms.linux;
  };
})
