{
  lib,
  callPackage,
  stdenv,
  hexdump,
  locale,
  fetchurl,
  python3,
  cmake,
  doxygen,
  gmp,
  graphviz,
  libxml2,
  libxslt,
  perl,
  pkg-config,
  qt6,
  shared-mime-info,
  lmdb,
  databaseLibrary ? lmdb, # can be built with tokyocabinet instead
  highDim ? false, # whether or not to include triangulations of dimension 9-15
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "regina-normal";
  version = "7.4.1";

  # Signed source tarball
  src = fetchurl {
    url = "https://github.com/regina-normal/regina/releases/download/regina-${finalAttrs.version}/regina-${finalAttrs.version}.tar.gz";
    hash = "sha256-dBMQFAmbdwg90dCQBP1ryXJCHHktGIzfQ/D9Ecpssu0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    doxygen
    libxslt
    pkg-config
    qt6.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs = [
    databaseLibrary
    gmp
    graphviz
    libxml2
    perl
    python3
    qt6.qtbase
    qt6.qtsvg
  ];

  postPatch = ''
    substituteInPlace python/regina/CMakeLists.txt \
      --replace-fail '$ENV{DESTDIR}''${Python_SITELIB}' "${placeholder "out"}/${python3.sitePackages}"
  '';

  cmakeFlags = [
    "-DREGINA_INSTALL_TYPE=XDG"
    "-DPython_EXECUTABLE=${python3.interpreter}"
  ]
  ++ lib.optionals highDim [ "-DHIGHDIM=1" ];

  doCheck = true;

  nativeCheckInputs = [
    perl
    hexdump
  ]
  ++ lib.optionals stdenv.buildPlatform.isDarwin [
    locale
  ];

  preCheck = ''
    patchShebangs --build \
      ../utils/testsuite/runtest.sh utils/testsuite/{genout,testall} python/{regina-python,testsuite/test*}
  '';
  preFixup = ''
    qtWrapperArgs+=(--set-default REGINA_PYLIBDIR "$out/${python3.sitePackages}")
  '';

  postFixup = ''
    # wrapQtAppsHook ignores files that are non-ELF executables
    wrapProgram $out/bin/regina-python \
      --set-default REGINA_PYLIBDIR $out/${python3.sitePackages}
  '';

  passthru.updateScript = [
    (callPackage ./update.nix { })
    finalAttrs.version
  ];

  meta = {
    description = "Software for low-dimensional topology";
    mainProgram = "regina-gui";
    homepage = "https://regina-normal.github.io";
    changelog = "https://regina-normal.github.io/#new";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ noiioiu ];
  };
})
