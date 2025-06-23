{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  libGLU,
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
  vcg,
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
in
stdenv.mkDerivation rec {
  pname = "meshlab";
  version = "2023.12";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    rev = "MeshLab-${version}";
    sha256 = "sha256-AdUAWS741RQclYaSE3Tz1/I0YSinNAnfSaqef+Tib8Y=";
  };

  buildInputs = [
    libGLU
    libsForQt5.qtbase
    libsForQt5.qtscript
    libsForQt5.qtxmlpatterns
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
    vcg
    libigl
    corto
    openctm
    structuresynth
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  preConfigure = ''
    substituteAll ${./meshlab.desktop} resources/linux/meshlab.desktop
    substituteInPlace src/external/tinygltf.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/tinygltf-2.6.3 ${tinygltf-src}
    substituteInPlace src/external/libigl.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/libigl-2.4.0 ${libigl}
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

  cmakeFlags = [
    "-DVCGDIR=${vcg.src}"
  ];

  postFixup = ''
    patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlab-wrapped
  '';

  # display a black screen on wayland, so force XWayland for now.
  # Might be fixed when upstream will be ready for Qt6.
  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = {
    description = "System for processing and editing 3D triangular meshes";
    mainProgram = "meshlab";
    homepage = "https://www.meshlab.net/";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
