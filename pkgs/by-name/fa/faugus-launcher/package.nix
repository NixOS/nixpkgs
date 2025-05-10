{
  bash,
  fetchFromGitHub,
  gamemode,
  gamescope,
  gobject-introspection,
  gtk3,
  icoextract,
  imagemagick,
  lib,
  libayatana-appindicator,
  libcanberra-gtk3,
  mangohud,
  nix-update-script,
  python3Packages,
  sc-controller,
  umu-launcher,
  wrapGAppsHook3,
  xdg-user-dirs,
}:

python3Packages.buildPythonApplication rec {
  pname = "faugus-launcher";
  version = "1.4.4";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = version;
    hash = "sha256-s3E28LHqdjnKO+BvKSBeuF+bOXPv/d2/+2G5U4rP+iA=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      filelock
      pillow
      psutil
      pygobject3
      pynput
      requests
      vdf
    ]
    ++ [
      icoextract
      imagemagick
      libcanberra-gtk3
      sc-controller
      xdg-user-dirs
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
      --replace-fail '/usr/share' "$out/share" \
      --replace-fail '/usr/bin/faugus-run' "$out/bin/.faugus-run-wrapped" \
      --replace-fail '/usr/bin/faugus-proton-manager' "$out/bin/.faugus-proton-manager-wrapped" \
      --replace-fail '/usr/bin/umu-run' "${lib.getExe' umu-launcher "umu-run"}" \
      --replace-fail '/usr/bin/mangohud' "${lib.getExe' mangohud "mangohud"}" \
      --replace-fail '/usr/bin/gamemoderun' "${lib.getExe' gamemode "gamemoderun"}" \
      --replace-fail 'shutil.copy(' 'shutil.copyfile('

    substituteInPlace faugus-run.py \
      --replace-fail '/usr/share' "$out/share" \
      --replace-fail '/usr/bin/faugus-components' "$out/bin/.faugus-components-wrapped" \
      --replace-fail '/usr/lib/libgamemode.so.0' "${lib.getLib gamemode}/lib/libgamemode.so.0" \
      --replace-fail '/usr/lib32/libgamemode.so.0' "${lib.getLib gamemode}/lib/libgamemode.so.0" \
      --replace-fail '/usr/lib/x86_64-linux-gnu/libgamemode.so.0' "${lib.getLib gamemode}/lib/libgamemode.so.0" \
      --replace-fail '/usr/lib64/libgamemode.so.0' "${lib.getLib gamemode}/lib/libgamemode.so.0" \
      --replace-fail '/bin/bash' "${lib.getExe' bash "bash"}"

    substituteInPlace faugus-proton-manager.py \
      --replace-fail '/usr/share' "$out/share"

    substituteInPlace faugus-session \
      --replace-fail '/bin/bash' "${lib.getExe' bash "bash"}" \
      --replace-fail 'gamescope' "${lib.getExe' gamescope "gamescope"}"
  '';

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
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
