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
    doxygen
    libxslt
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    databaseLibrary
    gmp
    graphviz
    jansson
    libxml2
    perl
    popt
    python3
    qt6.qtbase
    qt6.qtsvg
    shared-mime-info
  ];

  prePatch = ''
    substituteInPlace python/regina/CMakeLists.txt \
      --replace-fail '$ENV{DESTDIR}''${Python_SITELIB}' \
      "${placeholder "out"}/${python3.sitePackages}"
    patchShebangs utils/testsuite/*.{in,test,sh} python/testsuite/test*.in python/regina-python.in
  ''
  + lib.optionalString stdenv.buildPlatform.isDarwin ''
    substituteInPlace utils/testsuite/runtest.sh \
      --replace-fail "\`locale charmap 2>/dev/null\`" "UTF-8"
  '';

  cmakeFlags = [
    "-DREGINA_INSTALL_TYPE=XDG"
    "-DPYLIBDIR=${placeholder "out"}/${python3.sitePackages}"
    "-DCMAKE_POLICY_DEFAULT_CMP0153=OLD"
  ]
  ++ lib.optionals highDim [ "-DHIGHDIM=1" ];

  preFixup = ''
    qtWrapperArgs+=(--set-default REGINA_PYLIBDIR "$out/${python3.sitePackages}")
  '';

  postFixup = ''
    # wrapQtAppsHook ignores files that are non-ELF executables
    wrapProgram $out/bin/regina-python \
      --set-default REGINA_PYLIBDIR $out/${python3.sitePackages}
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ cppunit ];

  installCheckTarget = "test";

  meta = {
    description = "Software for low-dimensional topology";
    mainProgram = "regina-gui";
    homepage = "https://regina-normal.github.io";
    changelog = "https://regina-normal.github.io/#new";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
})
