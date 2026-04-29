{
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  gettext,
  hidapi,
  libGL,
  libGLU,
  libevdev,
  mkLibretroCore,
  pcre,
  pkg-config,
  sfml,
  udev,
  libxcb-util,
  libxxf86vm,
  libxrandr,
  libxi,
  libxinerama,
  libxext,
  libx11,
  libsm,
  libpthread-stubs,
  libxcb,
}:
mkLibretroCore {
  core = "dolphin";
  version = "0-unstable-2026-04-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dolphin";
    rev = "0cd3bb89c29535db9b7552fc86871867ccf5b471";
    hash = "sha256-cSiJO/EvspNvHopo/RLfuz8ONpbXk2NrrSDhkiAm7/s=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    cmake
    curl
    pkg-config
  ];
  extraBuildInputs = [
    gettext
    hidapi
    libGL
    libGLU
    libevdev
    pcre
    sfml
    udev
    libsm
    libx11
    libxext
    libxi
    libxinerama
    libxrandr
    libxxf86vm
    libpthread-stubs
    libxcb
    libxcb-util
  ];

  makefile = "Makefile";

  cmakeFlags = with lib.strings; [
    (cmakeBool "ENABLE_LTO" true)
    (cmakeBool "ENABLE_NOGUI" false)
    (cmakeBool "ENABLE_QT" false)
    (cmakeBool "ENABLE_TESTS" false)
    (cmakeBool "LIBRETRO" true)
    (cmakeBool "USE_SHARED_ENET" false)
    # Workaround the following error:
    # > CMake Error at 3rdparty/libzip/libzip/CMakeLists.txt:1 (cmake_minimum_required):
    # > Compatibility with CMake < 3.5 has been removed from CMake.
    #
    # > Update the VERSION argument <min> value.  Or, use the <min>...<max> syntax
    # > to tell CMake that the project requires at least <min> but has been updated
    # > to work with policies introduced by <max> or earlier.
    #
    # > Or, add -DCMAKE_POLICY_VERSION_MINIMUM=3.5 to try configuring anyway.
    (cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  dontUseCmakeBuildDir = false;

  meta = {
    description = "Port of Dolphin to libretro";
    homepage = "https://github.com/libretro/dolphin";
    license = lib.licenses.gpl2Plus;
  };
}
