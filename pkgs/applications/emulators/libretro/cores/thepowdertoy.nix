{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "thepowdertoy";
  version = "0-unstable-2025-09-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "ThePowderToy";
    rev = "cb3cd4c2e5beddb98b34e6b800fa24e8f96322d9";
    hash = "sha256-k3XWkkSuQC3IBhhI96qkTrlGH/oJu941HaAvR28V5i0=";
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
