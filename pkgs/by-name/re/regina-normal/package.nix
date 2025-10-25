{
  lib,
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
  stdenv,
  lmdb,
  databaseLibrary ? lmdb, # can be built with tokyocabinet instead
  highDim ? false, # whether or not to include triangulations of dimension 9-15
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "regina-normal";
  version = "7.4";

  # Signed source tarball
  src = fetchurl {
    url =
      with finalAttrs;
      "https://github.com/regina-normal/regina/releases/download/regina-${version}/regina-${version}.tar.gz";
    hash = "sha256-S4qC4cvReB/Fj7YAuisYPRLuQ0xfJwhNwGtyKp4/anY=";
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
