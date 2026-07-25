{
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  glslang,
  libevdev,
  libGL,
  libGLU,
  libx11,
  libxcb,
  libxcb-util,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  mkLibretroCore,
  pkg-config,
  udev,
}:
mkLibretroCore {
  core = "dolphin";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "dolphin";
    rev = "c6b869102f6b9f450f0a9878330d00484754879d";
    hash = "sha256-7sImbA1uzpwGovo4+5bK9SJpIDIvdB5FhN2IuxVaiQ8=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    cmake
    curl
    pkg-config
  ];

  extraBuildInputs = [
    glslang
    libGL
    libGLU
    libevdev
    libx11
    libxcb
    libxcb-util
    libxext
    libxi
    libxinerama
    libxrandr
    udev
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

  meta = {
    description = "Port of Dolphin to libretro";
    homepage = "https://github.com/libretro/dolphin";
    license = lib.licenses.gpl2Plus;
  };
}
