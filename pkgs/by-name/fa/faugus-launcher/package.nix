{
  bash,
  fetchFromGitHub,
  gamemode,
  gobject-introspection,
  icoextract,
  imagemagick,
  lib,
  libayatana-appindicator,
  libcanberra-gtk3,
  nix-update-script,
  python3Packages,
  umu-launcher,
  wrapGAppsHook3,
  xdg-utils,
}:

python3Packages.buildPythonApplication rec {
  pname = "faugus-launcher";
  version = "1.5.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Faugus";
    repo = "faugus-launcher";
    tag = version;
    hash = "sha256-NktdSkoS0ceHva/Q5VGzA1FFZN4KKitvV9IPVybBy44=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    libayatana-appindicator
  ];

  build-system = with python3Packages; [
    meson-python
  ];

  dependencies = with python3Packages; [
    evdev
    filelock
    pillow
    psutil
    pygobject3
    pynput
    requests
    vdf
  ];

  postPatch = ''
    substituteInPlace faugus_launcher.py \
      --replace-fail "PathManager.find_binary('faugus-run')" "'$out/bin/.faugus-run-wrapped'" \
      --replace-fail "PathManager.find_binary('faugus-proton-manager')" "'$out/bin/.faugus-proton-manager-wrapped'" \
      --replace-fail 'Exec={faugus_run}' 'Exec=faugus-run'

    substituteInPlace faugus_run.py \
      --replace-fail "PathManager.find_binary('faugus-components')" "'$out/bin/.faugus-components-wrapped'" \
      --replace-fail "PathManager.find_library('libgamemode.so.0')" "'${lib.getLib gamemode}/lib/libgamemode.so.0'" \
      --replace-fail "PathManager.find_library('libgamemodeauto.so.0')" "'${lib.getLib gamemode}/lib/libgamemodeauto.so.0'"

    substituteInPlace faugus-session \
      --replace-fail '/bin/bash' "${lib.getExe bash}"
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${
        lib.makeBinPath [
          icoextract
          imagemagick
          libcanberra-gtk3
          umu-launcher
          xdg-utils
        ]
      }"
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
