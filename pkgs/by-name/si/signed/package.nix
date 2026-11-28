{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  makeFontsConf,
  openssl,
  pkg-config,
  python3,
  qt6Packages,
  qpdf,
  nss,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "signed";
  version = "0.3.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "signed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gTaHcPbmHrXbg8qWuWrSgprEyy34imRrQUFPK4uBh0A=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  # Text stamped into PDFs asks for Noto Sans; like other font choices it is left to the
  # user (upstream's PKGBUILD depends on noto-fonts), and fontconfig falls back without it.
  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
    qt6Packages.qtwayland
    qt6Packages.poppler
    qpdf
  ];

  nativeCheckInputs = [
    ctestCheckHook
    nss.tools
    openssl
    python3
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$(mktemp -d)
    # The CLI tests count stderr lines, so silence fontconfig's missing-config error.
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ ]; }}
    export QT_PLUGIN_PATH="${qt6Packages.qtbase}/${qt6Packages.qtbase.qtPluginPrefix}:${qt6Packages.qtdeclarative}/${qt6Packages.qtbase.qtPluginPrefix}"
    export QML2_IMPORT_PATH="${qt6Packages.qtdeclarative}/${qt6Packages.qtbase.qtQmlPrefix}"
  '';

  # CMakeLists.txt has no install rules.
  installPhase = ''
    runHook preInstall
    install -Dm755 signed "$out/bin/signed"
    install -Dm644 ../pkgbuild/signed.svg "$out/share/icons/hicolor/scalable/apps/signed.svg"
    install -Dm644 ../pkgbuild/signed.desktop "$out/share/applications/signed.desktop"
    runHook postInstall
  '';

  # certutil and pk12util create and import the sealing certificates.
  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ nss.tools ])
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sign PDFs and fill them in with text and dates";
    homepage = "https://github.com/omacom/signed";
    changelog = "https://github.com/omacom/signed/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "signed";
  };
})
