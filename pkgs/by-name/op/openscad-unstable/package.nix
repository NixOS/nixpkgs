{ lib
, clangStdenv
, llvmPackages
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, bison
, boost
, cairo
, cgal_5
, clipper2
, double-conversion
, eigen
, flex
, fontconfig
, freetype
, glib
, glm
, gmp
, harfbuzz
, hidapi
, lib3mf
, libGL
, libGLU
, libICE
, libSM
, libsForQt5
, libspnav
, libzip
, mpfr
, python3
, tbb_2021_8
, wayland
, wayland-protocols
}:
let
  # get cccl from source to avoid license issues
  nvidia-cccl = clangStdenv.mkDerivation {
    pname = "nvidia-cccl";
    # note that v2.2.0 has some cmake issues
    version = "2.2.0-unstable-2024-01-26";
    src = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "cccl";
      fetchSubmodules = true;
      rev = "0c9d03276206a5f59368e908e3d643610f9fddcd";
      hash = "sha256-f11CNfa8jF9VbzvOoX1vT8zGIJL9cZ/VBpiklUn0YdU=";
    };
    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ tbb_2021_8 ];
    cmakeFlags = [
      # only enable what we need
      "-DCCCL_ENABLE_CUB=OFF"
      "-DCCCL_ENABLE_LIBCUDACXX=ON"
      "-DCCCL_ENABLE_THRUST=ON"
      "-DCCCL_ENABLE_TESTING=OFF"
      "-DCCCL_ENABLE_EXAMPLES=OFF"

      "-DTHRUST_DEVICE_SYSTEM=TBB"
      "-DTHRUST_HOST_SYSTEM=CPP"
      "-DTHRUST_ENABLE_HEADER_TESTING=OFF"
      "-DTHRUST_ENABLE_TESTING=OFF"
      "-DTHRUST_ENABLE_EXAMPLES=OFF"

      "-DLIBCUDACXX_ENABLE_CUDA=OFF"
      "-DLIBCUDACXX_ENABLE_STATIC_LIBRARY=OFF"
      "-DLIBCUDACXX_ENABLE_LIBCUDACXX_TESTS=OFF"
    ];
    meta = with lib; {
      description = "CUDA C++ Core Libraries";
      homepage = "https://github.com/NVIDIA/cccl";
      license = licenses.asl20;
      platforms = platforms.unix;
    };
  };
in
# clang consume much less RAM than GCC
clangStdenv.mkDerivation rec {
  pname = "openscad-unstable";
  version = "2024-01-22";
  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "88d244aed3c40a76194ff537ed84bd65bc0e1aeb";
    hash = "sha256-qkQNbYhmOxF14zm+eCcwe9asLOEciYBANefUb8+KNEI=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    bison
    flex
    python3
    libsForQt5.qt5.wrapQtAppsHook
    llvmPackages.bintools
  ];
  buildInputs = with libsForQt5; with qt5; [
    # manifold dependencies
    clipper2
    glm
    tbb_2021_8
    nvidia-cccl

    boost
    cairo
    cgal_5
    double-conversion
    eigen
    fontconfig
    freetype
    glib
    gmp
    harfbuzz
    hidapi
    lib3mf
    libspnav
    libzip
    mpfr
    qscintilla
    qtbase
    qtmultimedia
  ]
  ++ lib.optionals clangStdenv.isLinux [ libICE libSM libGLU libGL wayland wayland-protocols qtwayland ]
  ++ lib.optional clangStdenv.isDarwin qtmacextras
  ;
  cmakeFlags = [
    "-DEXPERIMENTAL=ON" # enable experimental options
    "-DSNAPSHOT=ON" # nightly icons
    "-DUSE_BUILTIN_OPENCSG=ON" # bundled latest opencsg
    "-DOPENSCAD_VERSION=\"${builtins.replaceStrings ["-"] ["."] version}\""
    "-DCMAKE_UNITY_BUILD=ON" # faster build
    "-DENABLE_TESTS=OFF" # tests do not work for now
    # IPO
    "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld"
    "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
  ];
  meta = with lib; {
    description = "3D parametric model compiler (unstable)";
    longDescription = ''
      OpenSCAD is a software for creating solid 3D CAD objects. It is free
      software and available for Linux/UNIX, MS Windows and macOS.

      Unlike most free software for creating 3D models (such as the famous
      application Blender) it does not focus on the artistic aspects of 3D
      modelling but instead on the CAD aspects. Thus it might be the
      application you are looking for when you are planning to create 3D models of
      machine parts but pretty sure is not what you are looking for when you are more
      interested in creating computer-animated movies.
    '';
    homepage = "https://openscad.org/";
    # note that the *binary license* is gpl3 due to CGAL
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pca006132 raskin ];
    mainProgram = "openscad";
  };
}
