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
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "isledecomp";
    repo = "isle-portable";
    rev = "f4a28f27f9d4b0e3511a86170d5b626c86720841";
    hash = "sha256-IZoX6yu4edA8JR4Q2qsIHeQ4ygW/av2QdPScqJbHUi4=";
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
