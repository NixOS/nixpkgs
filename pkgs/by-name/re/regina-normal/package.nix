{
  lib,
  fetchurl,
  python3,
  cmake,
  cppunit,
  doxygen,
  gmp,
  graphviz,
  jansson,
  libxml2,
  libxslt,
  perl,
  pkg-config,
  popt,
  qt6,
  shared-mime-info,
  stdenv,
  lmdb,
  databaseLibrary ? lmdb, # can be built with tokyocabinet instead
  highDim ? false, # whether or not to include triangulations of dimension 9-15
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "regina-normal";
  version = "7.3.1";

  # Signed source tarball
  src = fetchurl {
    url =
      with finalAttrs;
      "https://github.com/regina-normal/regina/releases/download/regina-${version}/regina-${version}.tar.gz";
    hash = "sha256-lfUJcNrK13DtwNOvlerwbEndalRzJ/WKtVQBx9Qcg/o=";
  };

  nativeBuildInputs = [
    cmake
    cppunit
    databaseLibrary
    doxygen
    gmp
    jansson
    libxml2
    libxslt
    pkg-config
    popt
    qt6.qtbase
    qt6.qtsvg
    qt6.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs = [
    graphviz
    perl
    python3
  ];

  prePatch = ''
    sed -e '42i #include <cstdint>' -i \
      engine/utilities/stringutils.h \
      engine/triangulation/facepair.h
    sed -e '16i cmake_policy(SET CMP0153 OLD)' -i \
      cmake/modules/FindSharedMimeInfo.cmake
    substituteInPlace python/regina/CMakeLists.txt \
      --replace-fail '$ENV{DESTDIR}${"$"}{Python_SITELIB}' \
      "${placeholder "out"}/${python3.sitePackages}"
    substituteInPlace python/regina-python.in \
      --replace-fail "my \$python_lib_dir = ${"''"}" \
      "my \$python_lib_dir = '${placeholder "out"}/${python3.sitePackages}'"
    patchShebangs utils/testsuite/*.{in,test,sh} python/testsuite/test*.in python/regina-python.in
  '';

  env = {
    NIX_CFLAGS_COMPILE = "-I${graphviz}/include/graphviz";
    PERL_PYLIBDIR = "${placeholder "out"}/${python3.sitePackages}";
    BASH_CMAKE_SOURCE_DIR = "${finalAttrs.src}";
  };

  cmakeFlags = [
    "-DREGINA_INSTALL_TYPE=XDG"
    "-DPython_EXECUTABLE=${python3.interpreter}"
    "-DPython_SITELIB=${python3.sitePackages}"
    "-DPYLIBDIR=${placeholder "out"}/${python3.sitePackages}"
  ]
  ++ lib.optionals highDim [ "-DHIGHDIM=1" ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    make test
    runHook postInstallCheck
  '';

  meta = {
    description = "Software for low-dimensional topology";
    mainProgram = "regina-gui";
    homepage = "https://regina-normal.github.io";
    changelog = "https://regina-normal.github.io/#new";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
})
