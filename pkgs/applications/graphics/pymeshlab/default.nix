{
  stdenv,
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
  onetbb,
  embree,
  vcg,
  libigl,
  corto,
  openctm,
  structuresynth,
  wrapQtAppsHook,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pymeshlab";
  version = "2023.12";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "pymeshlab";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IOlRdXoUPOJt67g3HqsLchV5aL+JUEks2y1Sy+wpwsg=";
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
    onetbb
    embree
    vcg
    libigl
    corto
    structuresynth
    openctm
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    python3Packages.pybind11
  ];

  propagatedBuildInputs = [
    python3Packages.numpy
  ];

  preConfigure = ''
    substituteInPlace src/meshlab/src/external/libigl.cmake \
      --replace-fail '$'{MESHLAB_EXTERNAL_DOWNLOAD_DIR}/libigl-2.4.0 ${libigl}
    substituteInPlace src/meshlab/src/external/nexus.cmake \
      --replace-fail '$'{NEXUS_DIR}/src/corto ${corto.src}
    substituteInPlace src/meshlab/src/external/levmar.cmake \
      --replace-fail '$'{LEVMAR_LINK} ${levmar.src} \
      --replace-warn "MD5 ''${LEVMAR_MD5}" ""
    substituteInPlace src/meshlab/src/external/ssynth.cmake \
      --replace-fail '$'{SSYNTH_LINK} ${structuresynth.src} \
      --replace-warn "MD5 ''${SSYNTH_MD5}" ""
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${python3Packages.python.sitePackages}/pymeshlab"
    "-DVCGDIR=${vcg.src}"
  ];

  meta = {
    description = "Open source mesh processing python library";
    homepage = "https://github.com/cnr-isti-vclab/PyMeshLab";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = with lib.platforms; linux;
  };
})
