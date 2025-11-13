{
  lib,
  fetchFromGitHub,
  stdenv,
  unstableGitUpdater,

  # Native Build Inputs
  cmake,
  python3,
  pkg-config,

  # Build Inputs
  xorg,
  wayland,
  libxkbcommon,
  wayland-protocols,
  glew,
  qt6,
  mesa,
  alsa-lib,
  sdl3,
  iniparser,

  # Options
  imguiDebug ? false,
  addrSan ? false,
  emscriptenHost ? "",
}:
stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  name = "isle-portable";
  version = "0-unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "isledecomp";
    repo = "isle-portable";
    rev = "39d2f52987b4c511158fa77748f72bb0c7301970";
    hash = "sha256-Ds45zDRPNuVWi7AdjzZEZYWaZH2z4LwT/xqAnvMSX5U=";
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace packaging/macos/CMakeLists.txt \
      --replace-fail "fixup_bundle" "#fixup_bundle"
  '';

  outputs = [
    "out"
    "lib"
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    python3
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    sdl3
    iniparser
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXcursor
    wayland
    libxkbcommon
    wayland-protocols
    glew
    mesa
    alsa-lib
  ];

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_DEPENDENCIES" false)
    (lib.cmakeBool "ISLE_DEBUG" imguiDebug)
    (lib.cmakeFeature "ISLE_EMSCRIPTEN_HOST" emscriptenHost)
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Portable decompilation of Lego Island";
    homepage = "https://github.com/isledecomp/isle-portable";
    license = with lib.licenses; [
      # The original code for the portable project
      lgpl3Plus
      # The decompilation code
      mit
      unfree
    ];
    platforms = with lib.platforms; windows ++ linux ++ darwin;
    mainProgram = "isle";
    maintainers = with lib.maintainers; [
      RossSmyth
    ];
  };
})
