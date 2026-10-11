{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  python3,
  rsync,
  bash,
  bc,
  coreutils,
  curl,
  deno,
  findutils,
  gawk,
  git,
  gnugrep,
  gnused,
  jq,
  procps,
  ripgrep,
  systemd,
  wget,
  xdg-user-dirs,
  xdg-utils,
  quickshell,
  wl-clipboard,
  cliphist,
  grim,
  slurp,
  playerctl,
  libnotify,
  glib,
  pipewire,
  pulseaudio,
  wireplumber,
  matugen,
  gowall,
  awww,
  inotify-tools,
  imagemagick,
  ffmpeg,
  kdePackages,
  qt6,
}:

let
  pythonRuntime = python3.withPackages (
    ps: with ps; [
      materialyoucolor
      material-color-utilities
      opencv4
      pillow
      numpy
      psutil
      tqdm
      loguru
      click
      pygobject3
      pycairo
      kde-material-you-colors
      websockets
      ytmusicapi
      yt-dlp
      secretstorage
    ]
  );

  runtimeDeps = [
    bash
    bc
    coreutils
    curl
    deno
    findutils
    gawk
    git
    gnugrep
    gnused
    jq
    procps
    pythonRuntime
    ripgrep
    rsync
    systemd
    wget
    xdg-user-dirs
    xdg-utils
    quickshell
    wl-clipboard
    cliphist
    grim
    slurp
    playerctl
    libnotify
    glib
    pipewire
    pulseaudio
    wireplumber
    matugen
    gowall
    awww
    inotify-tools
    imagemagick
    ffmpeg
  ];

  qmlDeps = [
    kdePackages.kirigami.passthru.unwrapped
    kdePackages.syntax-highlighting
    qt6.qt5compat
    qt6.qtdeclarative
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtquicktimeline
    qt6.qtsensors
    qt6.qtsvg
    qt6.qtvirtualkeyboard
    qt6.qtwayland
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "inir";
  version = "2.32.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LATAR-web";
    repo = "inir";
    rev = "dc8195889770b8303d6d6dfc0bc5172075137f6c";
    hash = "sha256-H6CEIk26ccCN3/QpC4/YvTg3+kllKlF/Qo+C9y9NQZs=";
  };

  nativeBuildInputs = [
    makeWrapper
    python3
    rsync
  ];

  preFixup = ''
    find "$out/share/quickshell/inir" -type f -name '*.py' -exec chmod -x {} +
  '';

  postFixup = ''
    find "$out/share/quickshell/inir" -type f -name '*.py' -exec chmod +x {} +
  '';

  installPhase = ''
    runHook preInstall

    runtime="$out/share/quickshell/inir"
    mkdir -p "$runtime" "$out/bin"

    python3 sdata/lib/runtime-payload.py copy --root . --target "$runtime"

    chmod +x "$runtime/setup" "$runtime/scripts/inir"
    find "$runtime/scripts" -type f \( -name '*.sh' -o -name '*.fish' -o -name '*.py' \) -exec chmod +x {} \;

    # Patch hardcoded /usr/bin for NixOS compatibility
    find "$runtime" \
      -type f \( -name '*.qml' -o -name '*.js' -o -name '*.sh' -o -name '*.py' \) \
      -exec sed -i '1!s#/usr/bin/##g' {} +

    makeWrapper "$runtime/scripts/inir" "$out/bin/inir" \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}" \
      --prefix QML2_IMPORT_PATH : "${lib.makeSearchPath "lib/qt-6/qml" qmlDeps}" \
      --prefix QT_PLUGIN_PATH : "${lib.makeSearchPath "lib/qt-6/plugins" qmlDeps}" \
      --set-default INIR_SYSTEM_RUNTIME_DIR "$runtime" \
      --set-default INIR_FALLBACK_SYSTEM_RUNTIME_DIR "$runtime" \
      --set-default INIR_VENV "${pythonRuntime}" \
      --set-default ILLOGICAL_IMPULSE_VIRTUAL_ENV "${pythonRuntime}"

    runHook postInstall
  '';

  meta = {
    description = "Complete desktop shell for Niri Wayland compositor, built on Quickshell";
    homepage = "https://github.com/LATAR-web/inir";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "inir";
  };
})
