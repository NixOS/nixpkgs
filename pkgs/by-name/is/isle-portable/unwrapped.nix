{
  lib,
  fetchFromGitHub,
  stdenv,
  callPackage,
  unstableGitUpdater,

  # Native Build Inputs
  cmake,
  ninja,
  python3,
  pkg-config,

  # Build Inputs
  libxrender,
  libxrandr,
  libxi,
  libxinerama,
  libxfixes,
  libxext,
  libxcursor,
  libx11,
  wayland,
  libxkbcommon,
  wayland-protocols,
  glew,
  qt6,
  alsa-lib,
  sdl3,
  iniparser,
  libweaver,

  # Options
  imguiDebug ? false,
  emscriptenHost ? "",
}:
stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  pname = "isle-portable";
  version = "0-unstable-2026-01-31";

  src = fetchFromGitHub {
    owner = "isledecomp";
    repo = "isle-portable";
    rev = "03cb40190a1aedea23b857942d14359c86ad3857";
    hash = "sha256-YGj+2FzotNmHrYBHmlMt6xuSXgXWa6j3rmukjUyGegA=";
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
    ninja
    qt6.wrapQtAppsHook
    python3
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    sdl3
    iniparser
    libweaver
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxext
    libxrandr
    libxrender
    libxfixes
    libxi
    libxinerama
    libxcursor
    wayland
    libxkbcommon
    wayland-protocols
    glew
    alsa-lib
  ];

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_DEPENDENCIES" false)
    (lib.cmakeBool "ISLE_DEBUG" imguiDebug)
    (lib.cmakeFeature "ISLE_EMSCRIPTEN_HOST" emscriptenHost)
  ];

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
    wrapped = callPackage ./package.nix {
      isle-portable-unwrapped = finalAttrs.finalPackage;
    };
  };

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
