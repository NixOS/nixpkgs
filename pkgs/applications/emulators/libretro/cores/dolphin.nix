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
  xorg,
}:
mkLibretroCore {
  core = "dolphin";
  version = "0-unstable-2025-08-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dolphin";
    rev = "83438f9b1a2c832319876a1fda130a5e33d4ef87";
    hash = "sha256-q4y+3uJ1tQ2OvlEvi/JNyIO/RfuWNIEKfVZ6xEWKFCg=";
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
    xorg.libSM
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libpthreadstubs
    xorg.libxcb
    xorg.xcbutil
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

  dontUseCmakeBuildDir = true;

  meta = {
    description = "Port of Dolphin to libretro";
    homepage = "https://github.com/libretro/dolphin";
    license = lib.licenses.gpl2Plus;
  };
}
