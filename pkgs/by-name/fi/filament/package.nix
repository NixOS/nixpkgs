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

  patches = [ ./0002-cmake-relocatable-target_include_directories.patch ];

  extraFindPackages = ''
    find_package(tsl-robin-map REQUIRED GLOBAL)
    add_library(tsl ALIAS tsl::robin_map)

    find_package(draco REQUIRED GLOBAL)
    add_library(dracodec ALIAS draco::draco_static)

    # find_package(SPIRV-Tools REQUIRED GLOBAL)
    # find_package(spirv_cross_core REQUIRED GLOBAL)
    # find_package(spirv_cross_glsl REQUIRED GLOBAL)
    # find_package(spirv_cross_msl REQUIRED GLOBAL)
    # find_package(glslang REQUIRED GLOBAL)
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
        # "assimp"
        # "stb"
        "draco"
        # "meshoptimizer"
        "robin-map"
        # They vendor an outdated imgui with different interfaces
        # "imgui"
        "libgtest"
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

    while IFS= read -r -d $'\0' path ; do
      sed -i "s/$installTargetsPattern/\1 EXPORT filament_target /" "$path"
    done < <( find libs/ -iname CMakeLists.txt -print0 )

    grep "install(TARGETS" $(find -iname CMakeLists.txt)

    cat << \EOF >> CMakeLists.txt
      include(CMakePackageConfigHelpers)
      configure_package_config_file(filament-config.cmake.in filament-config.cmake INSTALL_DESTINATION ''${CMAKE_INSTALL_LIBDIR}/cmake/filament)
      install(
        EXPORT filament_target FILE filament-targets.cmake
        DESTINATION ''${CMAKE_INSTALL_LIBDIR}/cmake/''${PROJECT_NAME})
    EOF
    cat << \EOF >> filament-config.cmake.in
    include("''${CMAKE_CURRENT_LIST_DIR}/imgui-targets.cmake")
    EOF

    cat libs/filameshio/CMakeLists.txt
  '';

  # installTargetsPattern = ''\(install(TARGETS[[:space:]]\+\([$][^$)[:space:]]\+\|[^)A-Z]\+\)\+[^)A-Z]*\)'';
  installTargetsPattern = ''\(install(TARGETS[[:space:]]\+\([$][{]\?[^$)[:space:]]\+[}]\?[^[:space:])]*\|[^$}{)A-Z]\+\)[[:space:]]*\)'';

  nativeBuildInputs = [
    cmake
    python3Packages.python
    spirv-tools
    spirv-cross
  ];
  buildInputs =
    [
      spirv-headers
      glslang
      # assimp
      stb
      draco
      gtest
      robin-map
      meshoptimizer
      # imgui
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
