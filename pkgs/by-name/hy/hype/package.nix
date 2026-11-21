{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  pkg-config,
  qt6,
  zlib,
  libwebp,
  source-highlight,
  ffmpeg,
  python3,
  makeFontsConf,
  noto-fonts,
  jetbrains-mono,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hype";
  version = "0.7.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    # CMakeLists.txt takes the version from a source directory named hype-<version>
    name = "hype-${finalAttrs.version}";
    owner = "omacom";
    repo = "hype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LeON8trdFa2xlLkSnBDXkuXs2pL9wKzh/FQFay47+Rw=";
  };

  # The fake highlighter must outlive the quit deadline; /usr/bin/sleep is missing in the sandbox
  # upstream: omacom/hype#63
  postPatch = ''
    substituteInPlace tests/test_shutdown.py \
      --replace-fail "/usr/bin/sleep 2" "sleep 2"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtimageformats
    qt6.qtsvg
    qt6.qtwayland
    zlib
    libwebp
  ];

  nativeCheckInputs = [
    ctestCheckHook
    python3
    ffmpeg
    source-highlight
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Without Qt Pdf (qtwebengine) this is a failing placeholder; passthru.tests.full runs it
  disabledTests = [ "hype_tests" ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export FONTCONFIG_FILE=${
      makeFontsConf {
        fontDirectories = [
          noto-fonts
          jetbrains-mono
        ];
      }
    }
    export QT_PLUGIN_PATH="${
      lib.concatMapStringsSep ":" (p: "${p}/${qt6.qtbase.qtPluginPrefix}") [
        qt6.qtbase
        qt6.qtdeclarative
        qt6.qtmultimedia
        qt6.qtimageformats
        qt6.qtsvg
      ]
    }"
    export QML2_IMPORT_PATH="${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix}:${qt6.qtmultimedia}/${qt6.qtbase.qtQmlPrefix}"
  '';

  # CMakeLists.txt has no install rules
  installPhase = ''
    runHook preInstall
    install -Dm755 hype "$out/bin/hype"
    install -Dm644 ../pkgbuild/hype.svg "$out/share/icons/hicolor/scalable/apps/hype.svg"
    install -Dm644 ../pkgbuild/hype.desktop "$out/share/applications/hype.desktop"
    runHook postInstall
  '';

  # Syntax highlighting and video export shell out to these.
  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      source-highlight
      ffmpeg
    ])
  ];

  # Also catches the version falling back to "dev" if the source directory name changes.
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    # The C++ tests read exported PDFs back with Qt Pdf, which would pull qtwebengine into the closure
    tests.full = finalAttrs.finalPackage.overrideAttrs (old: {
      checkInputs = old.checkInputs or [ ] ++ [ qt6.qtwebengine ];
      disabledTests = [ ];
    });
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Markdown presentations with a visual slide editor";
    homepage = "https://github.com/omacom/hype";
    changelog = "https://github.com/omacom/hype/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "hype";
  };
})
