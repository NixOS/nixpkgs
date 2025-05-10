{
  mkDerivation,
  lib,
  fetchFromGitHub,
  libGLU,
  qtbase,
  qtscript,
  qtxmlpatterns,
  lib3ds,
  bzip2,
  muparser,
  eigen,
  glew,
  gmp,
  levmar,
  qhull,
  cmake,
  cgal,
  boost,
  mpfr,
  xercesc,
  tbb,
  embree,
  libigl,
  corto,
  openctm,
  structuresynth,
}:

let
  tinygltf-src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    rev = "v2.6.3";
    hash = "sha256-IyezvHzgLRyc3z8HdNsQMqDEhP+Ytw0stFNak3C8lTo=";
  };
  # requires submodules to build
  lib3mf-src = fetchFromGitHub {
    owner = "3MFConsortium";
    repo = "lib3mf";
    rev = "v2.3.2";
    fetchSubmodules = true;
    hash = "sha256-pKjnN9H6/A2zPvzpFed65J+mnNwG/dkSE2/pW7IlN58=";
  };
in
mkDerivation {
  pname = "meshlab-unstable";
  version = "2023.12-unstable-2025-02-21";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    # note that this is in branch devel
    rev = "72142583980b6dbfc5b85c6cca226a72f48497a9";
    sha256 = "1q7qga4d82pvpcbsp9pi2i7nzdbflhp6q0d3y31kpch9r3r9pzks";
    # needed for an updated version of vcg in their submodule
    fetchSubmodules = true;
  };

  buildInputs = [
    libGLU
    qtbase
    qtscript
    qtxmlpatterns
    lib3ds
    bzip2
    muparser
    eigen
    glew
    gmp
    levmar
    qhull
    cgal
    boost
    mpfr
    xercesc
    tbb
    embree
    libigl
    corto
    openctm
    structuresynth
  ];

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    mkdir src/external/downloads
    cp -r --no-preserve=mode,ownership ${lib3mf-src} src/external/downloads/lib3mf-2.3.2

    substituteAll ${./meshlab.desktop} resources/linux/meshlab.desktop
    substituteInPlace src/external/tinygltf.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/tinygltf-2.6.3 ${tinygltf-src}
    substituteInPlace src/external/libigl.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/libigl-'$'{LIBIGL_VER} ${libigl}
    substituteInPlace src/external/nexus.cmake \
      --replace-fail '$'{NEXUS_DIR}/src/corto ${corto.src}
    substituteInPlace src/external/levmar.cmake \
      --replace-fail '$'{LEVMAR_LINK} ${levmar.src} \
      --replace-warn "MD5 ''${LEVMAR_MD5}" ""
    substituteInPlace src/external/ssynth.cmake \
      --replace-fail '$'{SSYNTH_LINK} ${structuresynth.src} \
      --replace-warn "MD5 ''${SSYNTH_MD5}" ""
    substituteInPlace src/common_gui/CMakeLists.txt \
      --replace-warn "MESHLAB_LIB_INSTALL_DIR" "CMAKE_INSTALL_LIBDIR"
  '';

  postFixup = ''
    patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlab-wrapped
    patchelf --add-needed $out/lib/meshlab/lib3mf.so $out/lib/meshlab/plugins/libio_3mf.so
  '';

  # display a black screen on wayland, so force XWayland for now.
  # Might be fixed when upstream will be ready for Qt6.
  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = {
    description = "System for processing and editing 3D triangular meshes (unstable)";
    mainProgram = "meshlab";
    homepage = "https://www.meshlab.net/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pca006132 ];
    platforms = with lib.platforms; linux;
  };
}
