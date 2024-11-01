{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  assimp,
  libGL,
  python3Packages,
  spirv-tools,
  spirv-cross,
  spirv-headers,
  glslang,
  draco,
  gtest,
  robin-map,
  meshoptimizer,
  xorg,
  imgui,
  stb,
}:

clangStdenv.mkDerivation rec {
  pname = "filament";
  version = "1.52.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "filament";
    rev = "v${version}";
    hash = "sha256-hKyyYSGvQnaS8vnYkm92PiSeMvjcIXza11ZvymhC+zk=";
  };

  # If you wish to un-vendor e.g. spirv-*, you could add extra find_package()s
  # and ALIAS libs here, so as to match the phony targets declared in  third_party/:
  extraFindPackages = ''
    find_package(tsl-robin-map REQUIRED GLOBAL)
    add_library(tsl ALIAS tsl::robin_map)

    find_package(draco REQUIRED GLOBAL)
    add_library(dracodec ALIAS draco::draco_static)
  '';

  postPatch = ''
    # Hard-codes libc++ for no reason, then fails with a warning-error about
    # the unused -stdlib argument
    sed -i 's/^.*libc++.*$//' CMakeLists.txt

    # Upstream vendors everything in the good world,
    # but most of the time their target_link_libraries() works
    # out of the box with out buildInputs simply because the sonames match
    sed -i 's/^.*add_subdirectory.*EXTERNAL.*\(${
      lib.concatStringsSep "\\|" [
        "draco"
        "robin-map"

        # They vendor an outdated imgui with different interfaces,
        # so we can't use ours:
        # "imgui"

        "libgtest"

        # Failed to un-vendor for various reasons:
        # "assimp"
        # "stb"
        # "meshoptimizer"
        # "spirv-tools"
        # "glslang"
        # "spirv-cross"
      ]
    }\).*$//' CMakeLists.txt

    substituteInPlace CMakeLists.txt \
      --replace-fail "# Sub-projects" "# Sub-projects
      $extraFindPackages"

    # Uses the otherwise undeclared uint32_t:
    sed -i "1i#include <cstdint>" tools/glslminifier/src/GlslMinify.h

    # An undeclared snprintf
    sed -i "1i#include <stdio.h>" third_party/vkmemalloc/tnt/../include/vk_mem_alloc.h

    # std::memcpy
    sed -i "1i#include <cstring>" libs/gltfio/src/extended/TangentsJobExtended.cpp

    # Add a detailed trace to an otherwise obscure script
    sed -i "2iset -x" build/linux/combine-static-libs.sh

    # Otherwise CMake fails to execute build/linux/combine-static-libs.sh
    patchShebangs .
  '';

  nativeBuildInputs = [
    cmake
    python3Packages.python
    spirv-tools
    spirv-cross
  ];
  buildInputs =
    [
      # assimp
      draco
      glslang
      gtest
      # imgui
      meshoptimizer
      robin-map
      spirv-headers
      stb
    ]
    ++ lib.optionals clangStdenv.hostPlatform.isLinux [
      libGL
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXxf86vm
    ];

  # Upstream hard-codes -Werror someplace that's hard to identify
  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  cmakeFlags = [
    # https://github.com/isl-org/Open3D/blob/f7161f4949d1a9c2b016899d2f8c7bdbfd6bf6f9/3rdparty/filament/filament_build.cmake#L74C11-L74C50
    (lib.cmakeFeature "FILAMENT_OPENGL_HANDLE_ARENA_SIZE_IN_MB" "20")
  ];

  meta = with lib; {
    description = "Filament is a real-time physically based rendering engine for Android, iOS, Windows, Linux, macOS, and WebGL2";
    homepage = "https://github.com/google/filament";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "filament";
    platforms = platforms.all;
  };
}
