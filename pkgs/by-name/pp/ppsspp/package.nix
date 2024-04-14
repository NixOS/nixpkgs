{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, copyDesktopItems
, ffmpeg_4
, glew
, libffi
, libsForQt5
, libzip
, makeDesktopItem
, makeWrapper
, pkg-config
, python3
, snappy
, vulkan-loader
, wayland
, zlib
, enableQt ? false
, enableVulkan ? true
, forceWayland ? false
}:

let
  # experimental, see https://github.com/hrydgard/ppsspp/issues/13845
  vulkanWayland = enableVulkan && forceWayland;
  inherit (libsForQt5) qtbase qtmultimedia wrapQtAppsHook;
in
# Only SDL frontend needs to specify whether to use Wayland
assert forceWayland -> !enableQt;
stdenv.mkDerivation (finalAttrs: {
  pname = "ppsspp"
          + lib.optionalString enableQt "-qt"
          + lib.optionalString (!enableQt) "-sdl"
          + lib.optionalString forceWayland "-wayland";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-I84zJqEE1X/eo/ukeGA2iZe3lWKvilk+RNGUzl2wZXY=";
  };

  postPatch = ''
    substituteInPlace git-version.cmake --replace unknown ${finalAttrs.src.rev}
    substituteInPlace UI/NativeApp.cpp --replace /usr/share $out/share
  '';

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    makeWrapper
    pkg-config
    python3
  ] ++ lib.optionals enableQt [ wrapQtAppsHook ];

  buildInputs = [
    SDL2
    ffmpeg_4
    (glew.override { enableEGL = forceWayland; })
    libzip
    snappy
    zlib
  ] ++ lib.optionals enableQt [
    qtbase
    qtmultimedia
  ] ++ lib.optionals enableVulkan [ vulkan-loader ]
  ++ lib.optionals vulkanWayland [ wayland libffi ];

  cmakeFlags = [
    (lib.cmakeBool "HEADLESS" (!enableQt))
    (lib.cmakeBool "USE_SYSTEM_FFMPEG" true)
    (lib.cmakeBool "USE_SYSTEM_LIBZIP" true)
    (lib.cmakeBool "USE_SYSTEM_SNAPPY" true)
    (lib.cmakeBool "USE_WAYLAND_WSI" vulkanWayland)
    (lib.cmakeBool "USING_QT_UI" enableQt)
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" "GLVND")
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "PPSSPP";
      name = "ppsspp";
      exec = "ppsspp";
      icon = "ppsspp";
      comment = "Play PSP games on your computer";
      categories = [ "Game" "Emulator" ];
    })
  ];

  installPhase = let
    vulkanPath = lib.makeLibraryPath [ vulkan-loader ];
  in
    ''
      runHook preInstall

      mkdir -p $out/share/{applications,ppsspp,icons}
    ''
    + (if enableQt then ''
      install -Dm555 PPSSPPQt $out/bin/ppsspp
      wrapProgram $out/bin/ppsspp \
    '' else ''
      install -Dm555 PPSSPPHeadless $out/bin/ppsspp-headless
      install -Dm555 PPSSPPSDL $out/share/ppsspp/
      makeWrapper $out/share/ppsspp/PPSSPPSDL $out/bin/ppsspp \
        --set SDL_VIDEODRIVER ${if forceWayland then "wayland" else "x11"} \
    '')
    + lib.optionalString enableVulkan ''
        --prefix LD_LIBRARY_PATH : ${vulkanPath} \
    ''
    + ''

      mv assets $out/share/ppsspp
      mv ../icons/hicolor $out/share/icons

      runHook postInstall
    '';

  meta = {
    homepage = "https://www.ppsspp.org/";
    description = "A HLE Playstation Portable emulator, written in C++ ("
                  + (if enableQt then "Qt" else "SDL + headless") + ")";
    longDescription = ''
      PPSSPP is a PSP emulator, which means that it can run games and other
      software that was originally made for the Sony PSP.

      The PSP had multiple types of software. The two most common are native PSP
      games on UMD discs and downloadable games (that were stored in the
      directory PSP/GAME on the "memory stick"). But there were also UMD Video
      discs, and PS1 games that could run in a proprietary emulator. PPSSPP does
      not run those.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    mainProgram = "ppsspp";
    platforms = lib.platforms.linux;
  };
})
