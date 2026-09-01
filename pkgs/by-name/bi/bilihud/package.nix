{
  autoPatchelfHook,
  cmake,
  desktop-file-utils,
  fetchFromGitHub,
  kdePackages,
  lib,
  ninja,
  pipewire,
  pkg-config,
  python3Packages,
  qt6,
  wayland,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bilihud";
  version = "0.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "locez";
    repo = "bilihud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E8EQ25Ofspy0o8iuBiWRGqhPQDug/fGrcvNbgWRrBO4=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace bilihud.desktop \
      --replace-fail "Categories=Utility;Network;" "Categories=AudioVideo;"
  '';

  build-system = [ python3Packages.scikit-build-core ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.layer-shell-qt
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    wayland
  ];

  dependencies = with python3Packages; [
    aiohttp
    brotli
    keyring
    pillow
    pure-protobuf
    pyqt6
    qasync
    qrcode
  ];

  dontUseCmakeConfigure = true;
  # Qt's setup hook supplies cmake.args on the CLI, overriding pyproject.toml.
  pypaBuildFlags = [
    "--config-setting=cmake.define.BILIHUD_INSTALL_DIR=bilihud"
    "--config-setting=cmake.define.BILIHUD_LAYER_SHELL=ON"
  ];

  # Let the Python application wrapper carry Qt's plugin and platform paths.
  dontWrapQtApps = true;
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ pipewire ])
  ];

  postInstall = ''
    install -Dm644 bilihud.desktop "$out/share/applications/bilihud.desktop"
    install -Dm644 src/bilihud/assets/icon.png \
      "$out/share/icons/hicolor/256x256/apps/bilihud.png"
    install -Dm644 LICENSE "$out/share/licenses/bilihud/LICENSE"
    install -Dm644 vendor/blivedm/LICENSE \
      "$out/share/licenses/bilihud/blivedm-LICENSE"
  '';

  pythonImportsCheck = [
    "bilihud"
    "blivedm"
    "bilihud.platform.layer_shell"
    "PyQt6.QtMultimedia"
    "PyQt6.QtSvg"
  ];

  nativeCheckInputs = [ desktop-file-utils ];
  doCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    test -x "$out/bin/bilihud"
    test -f "$out/${python3Packages.python.sitePackages}/bilihud/libbili-layer.so"
    desktop-file-validate "$out/share/applications/bilihud.desktop"
    env -u LD_LIBRARY_PATH "$out/bin/bilihud" --help > /dev/null
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ pipewire ]}:''${LD_LIBRARY_PATH-}"
    PYTHONPATH="$out/${python3Packages.python.sitePackages}:''${PYTHONPATH-}" \
      ${python3Packages.python.interpreter} -c \
        "from pathlib import Path; import bilihud; \
        from bilihud.platform.layer_shell import load_layer_shell_bridge; \
        bridge, error = load_layer_shell_bridge(Path(bilihud.__file__).parent); \
        assert bridge is not None, error"

    runHook postInstallCheck
  '';

  strictDeps = true;

  meta = {
    description = "Bilibili live-stream danmaku overlay for fullscreen games";
    homepage = "https://github.com/locez/bilihud";
    changelog = "https://github.com/locez/bilihud/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _27Aaron ];
    mainProgram = "bilihud";
    platforms = lib.platforms.linux;
  };
})
