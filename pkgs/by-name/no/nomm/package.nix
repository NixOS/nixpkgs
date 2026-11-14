{
  lib,
  fetchFromGitHub,
  unrar,
  p7zip,
  wrapGAppsHook4,
  libadwaita,
  libnotify,
  gobject-introspection,
  python3,
  python3Packages,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nomm";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NOMM-Team";
    repo = "nomm-app";
    rev = "${finalAttrs.version}";
    hash = "sha256-Si0y5Dkb1t7uvDrO3SXELpkCVZ96mciLu2FK/x+BhSA=";
  };

  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace src/nomm/core/tools.py \
    --replace-fail 'release_bites_path = "/app/bin/release_bites.yaml"' \
    'release_bites_path = "${placeholder "out"}/bin/release_bites.yaml"'
    substituteInPlace src/nomm/gui/dashboard.py \
    --replace-fail 'rarfile.UNRAR_TOOL = "/app/bin/unrar"' \
    'rarfile.UNRAR_TOOL = "${unrar}/bin/unrar"'
    substituteInPlace src/nomm/core/archive_manager.py \
    --replace-fail 'rarfile.UNRAR_TOOL = "/app/bin/unrar"' \
    'rarfile.UNRAR_TOOL = "${unrar}/bin/unrar"'
    substituteInPlace src/nomm/core/archive_manager.py \
    --replace-fail '["7z", "x", archive_path, f"-o{destination_path}", "-y"],' \
    '["${p7zip}/bin/7za", "x", archive_path, f"-o{destination_path}", "-y"],'
    substituteInPlace src/nomm/gui/application.py \
    --replace-fail "LOCALE_DIR = '/app/share/locale'" \
    "LOCALE_DIR = '${placeholder "out"}/share/locale'"
  '';

  buildInputs = [
    libadwaita
    libnotify
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  build-system = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    requests
    vdf
    pyyaml
    rarfile
    dulwich
    packaging
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    install -Dm644 src/nomm/shenanigans.yaml $out/bin/shenanigans.yaml
    install -Dm644 release_bites.yaml $out/bin/release_bites.yaml
    install -Dm644 build/flatpak/moe.nomm.Nomm.desktop $out/share/applications/moe.nomm.Nomm.desktop
    install -Dm644 build/flatpak/moe.nomm.Nomm.metainfo.xml $out/share/metainfo/moe.nomm.Nomm.metainfo.xml
    install -Dm644 assets/icons/nomm-logo.svg $out/share/icons/hicolor/scalable/apps/moe.nomm.Nomm.svg
    install -d $out/share/icons/hicolor/scalable/actions
    cp -r assets/icons/*.svg $out/share/icons/hicolor/scalable/actions/
    find locale -name "*.po" | while read -r po; do
      language_code=$(basename "$po" .po)
      install -d "$out/share/locale/$language_code/LC_MESSAGES"
      msgfmt "$po" -o "$out/share/locale/$language_code/LC_MESSAGES/moe.nomm.Nomm.mo"
    done
  '';

  preInstallCheck = ''
    export HOME=$(mktemp -d)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nomm --help
    runHook postInstallCheck
  '';

  meta = {
    description = "A GTK-based remote control for Android TV devices";
    homepage = "https://github.com/NOMM-Team/nomm-app";
    maintainers = with lib.maintainers; [ lethargii ];
    changelog = "https://github.com/NOMM-Team/nomm-app/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "nomm";
    platforms = lib.platforms.linux;
  };
})
