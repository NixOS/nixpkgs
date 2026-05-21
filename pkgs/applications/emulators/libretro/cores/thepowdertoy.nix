{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "thepowdertoy";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ThePowderToy";
    rev = "dcb5e41f1f9800192ea07ea43459413c5a065d9f";
    hash = "sha256-FDotG/ngmrxgyN7YQ8SK/ZQHKWkwZ5hhg0qsNNXmaNc=";
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
