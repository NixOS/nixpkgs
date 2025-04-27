{
  bash,
  fetchFromGitHub,
  gamemode,
  gobject-introspection,
  gtk3,
  icoextract,
  imagemagick,
  lib,
  libayatana-appindicator,
  libcanberra-gtk3,
  nix-update-script,
  python3Packages,
  umu-launcher,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "faugus-launcher";
  version = "1.5.5";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = version;
    hash = "sha256-K87aivJ/cNLcoSZc4G+U2azw7I4sIjTb8bU/bN+c29o=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
  ];

  propagatedBuildInputs = with python3Packages; [
    filelock
    pillow
    psutil
    pygobject3
    pynput
    requests
    vdf
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 faugus-launcher.py "$out/bin/faugus-launcher"
    install -Dm755 faugus-run.py "$out/bin/faugus-run"
    install -Dm755 faugus-proton-manager.py "$out/bin/faugus-proton-manager"
    install -Dm755 faugus-components.py "$out/bin/faugus-components"
    install -Dm755 faugus-gamepad.py "$out/bin/faugus-gamepad"
    install -Dm755 faugus-session "$out/bin/faugus-session"
    install -Dm644 faugus-launcher.desktop "$out/share/applications/faugus-launcher.desktop"
    install -Dm644 assets/faugus-launcher.png "$out/share/icons/hicolor/256x256/apps/faugus-launcher.png"
    install -Dm644 assets/faugus-battlenet.png "$out/share/icons/hicolor/256x256/apps/faugus-battlenet.png"
    install -Dm644 assets/faugus-ea.png "$out/share/icons/hicolor/256x256/apps/faugus-ea.png"
    install -Dm644 assets/faugus-epic-games.png "$out/share/icons/hicolor/256x256/apps/faugus-epic-games.png"
    install -Dm644 assets/faugus-ubisoft-connect.png "$out/share/icons/hicolor/256x256/apps/faugus-ubisoft-connect.png"
    install -Dm644 assets/faugus-banner.png "$out/share/faugus-launcher/faugus-banner.png"
    install -Dm644 assets/faugus-notification.ogg "$out/share/faugus-launcher/faugus-notification.ogg"

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace faugus-launcher.py \
      --replace-fail "PathManager.find_binary('faugus-run')" "'$out/bin/.faugus-run-wrapped'" \
      --replace-fail "PathManager.find_binary('faugus-proton-manager')" "'$out/bin/.faugus-proton-manager-wrapped'" \
      --replace-fail 'Exec={faugus_run}' 'Exec=faugus-run'

    substituteInPlace faugus-run.py \
      --replace-fail "PathManager.find_binary('faugus-components')" "'$out/bin/.faugus-components-wrapped'" \
      --replace-fail "PathManager.find_library('libgamemode.so.0')" "'${lib.getLib gamemode}/lib/libgamemode.so.0'" \
      --replace-fail "PathManager.find_library('libgamemodeauto.so.0')" "'${lib.getLib gamemode}/lib/libgamemodeauto.so.0'"

    substituteInPlace faugus-session \
      --replace-fail '/bin/bash' "${lib.getExe bash}"
  '';

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${
        lib.makeBinPath [
          icoextract
          imagemagick
          libcanberra-gtk3
          umu-launcher
        ]
      }
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple and lightweight app for running Windows games using UMU-Launcher";
    homepage = "https://github.com/Faugus/faugus-launcher";
    changelog = "https://github.com/Faugus/faugus-launcher/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "faugus-launcher";
    platforms = lib.platforms.linux;
  };
}
