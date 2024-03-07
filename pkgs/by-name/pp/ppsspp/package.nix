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
  version = "1.16.6";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-FCdYvYKcV+0TpQUSWiooNlTXKYtqbfnAWwjk7M8iF1Q=";
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
  ] ++ lib.optional enableQt wrapQtAppsHook;

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
      mv ../icons/hicolor $out/share/icons

      runHook postInstall
    '';

  meta = {
    homepage = "https://www.ppsspp.org/";
    description = "A HLE Playstation Portable emulator, written in C++ ("
                  + (if enableQt then "Qt" else "SDL + headless") + ")";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
