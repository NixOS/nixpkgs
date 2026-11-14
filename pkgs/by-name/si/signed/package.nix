{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  poppler,
  qpdf,
  nss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "signed";
  version = "0.3.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "signed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fH5jXdO0uNsRblramzU0lcP3Dvv7pMZjf41FdE3lKjY=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    qt6.qtdeclarative
    qt6.qtwayland
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    (poppler.override {
      qt6Support = true;
      inherit (qt6) qtbase;
    })
    qpdf
    nss
  ];

  nativeCheckInputs = [
    nss.tools
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ nss.tools ])
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    mkdir -p build/tests
    pushd build/tests
    qmake ../../tests/signed_tests.pro
    make -j$NIX_BUILD_CORES
    QT_QPA_PLATFORM=offscreen QML2_IMPORT_PATH="${qt6.qtdeclarative}/lib/qt-6/qml" ./signed_tests
    popd
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 signed "$out/bin/signed"
    install -Dm644 pkgbuild/signed.svg "$out/share/icons/hicolor/scalable/apps/signed.svg"
    install -Dm644 pkgbuild/signed.desktop "$out/share/applications/signed.desktop"
    runHook postInstall
  '';

  meta = {
    description = "Sign PDFs and fill them in with text and dates";
    homepage = "https://github.com/omacom/signed";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "signed";
  };
})
