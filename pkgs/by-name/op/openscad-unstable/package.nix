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
, ghostscript
, glib
, glm
, gmp
, harfbuzz
, hidapi
, lib3mf
, libGLU
, libICE
, libSM
, libsForQt5
, libspnav
, libzip
, mesa
, mpfr
, python3
, tbb_2021_11
, wayland
, wayland-protocols
, wrapGAppsHook3
, xorg
}:
let
  # get cccl from source to avoid license issues
  nvidia-cccl = clangStdenv.mkDerivation {
    pname = "nvidia-cccl";
    # note, after v2.2.0, manifold dependency fails with some swap() ambiguities
    version = "2.2.0";
    src = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "cccl";
      fetchSubmodules = true;
      rev = "v2.2.0";
      hash = "sha256-azHDAuK0rAHrH+XkN3gHDrbwZOclP3zbEMe8VRpMjDQ=";
    };
    patches = [ ./thrust-cmake.patch ];
    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ tbb_2021_11 ];
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
  version = "2024-08-17";
  src = fetchFromGitHub {
    owner = "openscad";
    repo = "openscad";
    rev = "a16ca2a670840cfecb76254967380385d4d573cb";
    hash = "sha256-YadbrYaxxdVNejasFW0MbcYwjwTHHQbVjqen9PKEsYQ=";
    fetchSubmodules = true;
  };
  patches = [ ./test.diff ];
  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ numpy pillow ]))
    bison
    cmake
    flex
    libsForQt5.qt5.wrapQtAppsHook
    llvmPackages.bintools
    wrapGAppsHook3
    ninja
    pkg-config
  ];
  buildInputs = with libsForQt5; with qt5; [
    # manifold dependencies
    clipper2
    glm
    tbb_2021_11
    nvidia-cccl

    boost
    cairo
    cgal_5
    double-conversion
    eigen
    fontconfig
    freetype
    ghostscript
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
  ++ lib.optionals clangStdenv.isLinux [
    xorg.libXdmcp
    libICE
    libSM
    wayland
    wayland-protocols
    qtwayland
    libGLU
  ]
  ++ lib.optional clangStdenv.isDarwin qtmacextras
  ;
  cmakeFlags = [
    "-DEXPERIMENTAL=ON" # enable experimental options
    "-DSNAPSHOT=ON" # nightly icons
    "-DUSE_BUILTIN_OPENCSG=ON" # bundled latest opencsg
    "-DOPENSCAD_VERSION=\"${builtins.replaceStrings ["-"] ["."] version}\""
    "-DCMAKE_UNITY_BUILD=ON" # faster build
    # IPO
    "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld"
    "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON"
  ];

  doCheck = true;

  nativeCheckInputs = [
    mesa.llvmpipeHook
  ];

  checkPhase = ''
    # some fontconfig issues cause pdf output to have wrong font
    ctest -j$NIX_BUILD_CORES -E pdfexporttest.\*
  '';
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
