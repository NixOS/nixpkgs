{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "thepowdertoy";
  version = "0-unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ThePowderToy";
    rev = "bb2d9f6623d2ccf25a0021045af9591c8a0bbaff";
    hash = "sha256-iYGIDpum2x3sE8dBsZQOVv70C20Ras2CTlam0AldeLM=";
  };

  extraNativeBuildInputs = [ cmake ];

  cmakeFlags = with lib.strings; [
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

  makefile = "Makefile";

  postBuild = "cd src";

  meta = {
    description = "Port of The Powder Toy to libretro";
    homepage = "https://github.com/libretro/ThePowderToy";
    license = lib.licenses.gpl3Only;
  };
}
