{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, copyDesktopItems
, ffmpeg
, glew
, libffi
, libzip
, makeDesktopItem
, makeWrapper
, pkg-config
, python3
, qtbase ? null
, qtmultimedia ? null
, snappy
, vulkan-loader
, wayland
, wrapQtAppsHook ? null
, zlib
, enableVulkan ? true
, forceWayland ? false
}:

let
  enableQt = (qtbase != null);
  frontend = if enableQt then "Qt" else "SDL and headless";
  vulkanPath = lib.makeLibraryPath [ vulkan-loader ];

  # experimental, see https://github.com/hrydgard/ppsspp/issues/13845
  vulkanWayland = enableVulkan && forceWayland;
in
  # Only SDL front end needs to specify whether to use Wayland
  assert forceWayland -> !enableQt;
  stdenv.mkDerivation (finalAttrs: {
    pname = "ppsspp"
      + lib.optionalString enableQt "-qt"
      + lib.optionalString (!enableQt) "-sdl"
      + lib.optionalString forceWayland "-wayland";
    version = "1.14.4";

    src = fetchFromGitHub {
      owner = "hrydgard";
      repo = "ppsspp";
      rev = "v${finalAttrs.version}";
      fetchSubmodules = true;
      sha256 = "sha256-7xzhN8JIQD4LZg8sQ8rLNYZrW0nCNBfZFgzoKdoWbKc=";
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
      wrapQtAppsHook
    ];

    buildInputs = [
      SDL2
      ffmpeg
      (glew.override { enableEGL = forceWayland; })
      libzip
      qtbase
      qtmultimedia
      snappy
      zlib
    ] ++ lib.optional enableVulkan vulkan-loader
      ++ lib.optionals vulkanWayland [ wayland libffi ];

    cmakeFlags = [
      "-DHEADLESS=${if enableQt then "OFF" else "ON"}"
      "-DOpenGL_GL_PREFERENCE=GLVND"
      "-DUSE_SYSTEM_FFMPEG=ON"
      "-DUSE_SYSTEM_LIBZIP=ON"
      "-DUSE_SYSTEM_SNAPPY=ON"
      "-DUSE_WAYLAND_WSI=${if vulkanWayland then "ON" else "OFF"}"
      "-DUSING_QT_UI=${if enableQt then "ON" else "OFF"}"
    ];

    desktopItems = [(makeDesktopItem {
      desktopName = "PPSSPP";
      name = "ppsspp";
      exec = "ppsspp";
      icon = "ppsspp";
      comment = "Play PSP games on your computer";
      categories = [ "Game" "Emulator" ];
    })];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/{applications,ppsspp}
    '' + (if enableQt then ''
      install -Dm555 PPSSPPQt $out/bin/ppsspp
      wrapProgram $out/bin/ppsspp \
    '' else ''
      install -Dm555 PPSSPPHeadless $out/bin/ppsspp-headless
      install -Dm555 PPSSPPSDL $out/share/ppsspp/
      makeWrapper $out/share/ppsspp/PPSSPPSDL $out/bin/ppsspp \
        --set SDL_VIDEODRIVER ${if forceWayland then "wayland" else "x11"} \
    '') + lib.optionalString enableVulkan ''
        --prefix LD_LIBRARY_PATH : ${vulkanPath} \
    '' + "\n" + ''
      mv assets $out/share/ppsspp
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://www.ppsspp.org/";
      description = "A HLE Playstation Portable emulator, written in C++ (${frontend})";
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ AndersonTorres ];
      platforms = platforms.linux;
    };
  })
