{
  lib,
  stdenv,
  fetchFromGitHub,
  balena-cli,
  cdrdao,
  desktopToDarwinBundle,
  ffmpeg,
  libsecret,
  mame-tools,
  nix-update-script,
  python3Packages,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mister-companion";
  version = "8.11.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Anime0t4ku";
    repo = "mister-companion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LmRef8Y9I1RufO+uNXqQ23MjEGaff+2EVZs0f2eNLpU=";
  };

  sourceRoot = "${finalAttrs.src.name}/mister-companion";

  # Disable updates
  # Use apps from nixpkgs
  postPatch = ''
    substituteInPlace core/updater.py core/mc_updater.py \
      --replace-fail "def updater_supported() -> bool:" "def updater_supported() -> bool:
        return False"

    substituteInPlace ui/main_window.py \
      --replace-fail "def start_update_check(self, show_no_update: bool, show_errors: bool):" "def start_update_check(self, show_no_update: bool, show_errors: bool):
            return"

    substituteInPlace ui/tabs/app_settings_tab.py \
      --replace-fail "settings_layout.addWidget(updates_group)" "settings_layout.addWidget(updates_group)
            updates_group.hide()"

    substituteInPlace core/app_paths.py \
      --replace-fail 'return sys.platform == "darwin" and is_packaged_app()' 'return sys.platform == "darwin"'

    substituteInPlace core/chd_converter.py \
      --replace-fail 'CHDMAN_DIR = generated_path("tools", "chdman")' 'CHDMAN_DIR = Path("${lib.getBin mame-tools}/bin")' \
      --replace-fail "def remove_chdman() -> None:" "def remove_chdman() -> None:
        return"

    substituteInPlace core/flasher.py \
      --replace-fail 'BALENA_DIR = TOOLS_DIR / "balena-cli"' 'BALENA_DIR = Path("${lib.getBin balena-cli}/bin")' \
      --replace-fail "def remove_balena_cli(log_callback: LogCallback | None = None) -> None:" "def remove_balena_cli(log_callback: LogCallback | None = None) -> None:
        return"

    substituteInPlace core/video_converter.py \
      --replace-fail 'FFMPEG_DIR = generated_path("tools", "ffmpeg")' 'FFMPEG_DIR = Path("${lib.getBin ffmpeg}/bin")' \
      --replace-fail "def remove_ffmpeg() -> None:" "def remove_ffmpeg() -> None:
        return"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace core/disc_tools.py \
      --replace-fail 'CDRDAO_DIR = generated_path("tools", "cdrdao")' 'CDRDAO_DIR = Path("${lib.getBin cdrdao}/bin")' \
      --replace-fail "def remove_cdrdao() -> None:" "def remove_cdrdao() -> None:
        return"
  '';

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

  dependencies = with python3Packages; [
    certifi
    cryptography
    paramiko
    pillow
    psutil
    pycdlib
    pyqt6
    pyserial
    requests
    websocket-client
  ];

  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ libsecret ])
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mister-companion
    cp -r assets core ui main.py $out/share/mister-companion/
    install -Dm644 MiSTer-Companion.desktop -t $out/share/applications
    install -Dm644 assets/icon.png $out/share/icons/hicolor/256x256/apps/mister-companion.png

    runHook postInstall
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # Doesn't work
  disabledTests = [ "test_private_repository_and_network_failure" ];

  dontWrapPythonPrograms = true;
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    makeWrapper ${lib.getExe python3Packages.python} $out/bin/MiSTer-Companion \
      "''${makeWrapperArgs[@]}" \
      --prefix PYTHONPATH : ${python3Packages.makePythonPath finalAttrs.passthru.dependencies} \
      --add-flags $out/share/mister-companion/main.py
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to manage and maintain MiSTer FPGA systems over SSH or from an SD card";
    homepage = "https://github.com/Anime0t4ku/mister-companion";
    changelog = "https://github.com/Anime0t4ku/mister-companion/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "MiSTer-Companion";
    mainDarwinApp = "MiSTer Companion.app";
  };
})
