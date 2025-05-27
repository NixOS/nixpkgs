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
    libxml2
    perl
    python3
    qt6.qtbase
    qt6.qtsvg
    shared-mime-info
  ];

  postPatch = ''
    substituteInPlace python/regina/CMakeLists.txt \
      --replace-fail '$ENV{DESTDIR}''${Python_SITELIB}' "${placeholder "out"}/${python3.sitePackages}"
    patchShebangs utils/testsuite/*.{in,test,sh} python/testsuite/test*.in python/regina-python.in
  '';

  cmakeFlags = [
    "-DREGINA_INSTALL_TYPE=XDG"
    "-DPYLIBDIR=${placeholder "out"}/${python3.sitePackages}"
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

  nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    hexdump
    locale
  ];

  installCheckTarget = "test";

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
