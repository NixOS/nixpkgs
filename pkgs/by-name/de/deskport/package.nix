# Adapted from the Nixpkgs moonlight-qt recipe (MIT); see Nixpkgs COPYING.
{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,
  pkg-config,
  vulkan-headers,
  SDL2,
  SDL2_ttf,
  ffmpeg_8,
  libopus,
  libplacebo,
  openssl,
  alsa-lib,
  libpulseaudio,
  libva,
  libvdpau,
  libxkbcommon,
  wayland,
  libdrm,
  python3,
  pipewire,
  callPackage,
  testers,
  runCommand,
  writeShellScript,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deskport";
  version = "0.6.3";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "keithxc";
    repo = "deskport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OMnrncj+26zAD9rdDmfoSJ7n7RXSg0LTB+uh6wxotCI=";
  };

  patches = [ ./non-vulkan-window.patch ];

  deskportCore = fetchFromGitHub {
    owner = "keithxc";
    repo = "deskport-core";
    rev = "e71b21808e15c8bcd55d4af3f7c0cbc769ef0bcb";
    hash = "sha256-i0xnKNa1MxI2yGT9ISaIrwZuytDIiyIPUZ/2jxYbj18=";
  };

  sessionHost = callPackage ./host.nix {
    deskportSource = finalAttrs.src;
    deskportVersion = finalAttrs.version;
  };

  # Even --version initializes Sunshine's config directory. Keep it private,
  # including when called outside DeskPort or from a systemd user service.
  sessionHostLauncher = writeShellScript "deskport-host" ''
    unset CONFIGURATION_DIRECTORY
    export SUNSHINE_MIGRATE_CONFIG=0
    case "''${1:-}" in
      /*.conf) export XDG_CONFIG_HOME="$(${lib.getExe' coreutils "dirname"} -- "$1")/runtime" ;;
      *) export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}/DeskPort/host-runtime" ;;
    esac
    ${lib.getExe' coreutils "mkdir"} -p "$XDG_CONFIG_HOME"
    exec ${finalAttrs.sessionHost}/bin/sunshine "$@"
  '';

  postUnpack = ''
    cp -R --no-preserve=mode ${finalAttrs.deskportCore}/. "$sourceRoot/shared/deskport-core/"
  '';

  nativeBuildInputs = [
    python3
    qt6.qttools
    qt6.qmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    vulkan-headers
    pipewire
    SDL2
    SDL2_ttf
    ffmpeg_8
    libopus
    libplacebo
    qt6.qtdeclarative
    qt6.qtsvg
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
    libva
    libvdpau
    libxkbcommon
    qt6.qtwayland
    wayland
    libdrm
  ];

  qmakeFlags = [ "CONFIG+=disable-prebuilts" ];

  preBuild = ''
    python3 shared/deskport-core/tests/test_workspace.py --qt-header app/backend/workspaceresolution.h
  '';

  postInstall = ''
    mkdir -p "$out/libexec"
    ln -s ${finalAttrs.sessionHostLauncher} "$out/libexec/deskport-host"
    cat > "$out/share/applications/io.github.keithxc.DeskPort.display.desktop" <<EOF
    [Desktop Entry]
    Type=Application
    Name=DeskPort virtual display permission
    Exec=$out/libexec/deskport-display
    NoDisplay=true
    X-KDE-Wayland-Interfaces=zkde_screencast_unstable_v1
    EOF
  '';

  postFixup = ''
    cp "$out/share/applications/io.github.keithxc.DeskPort.display.desktop" \
      "$out/share/applications/io.github.keithxc.DeskPort.display-native.desktop"
    substituteInPlace "$out/share/applications/io.github.keithxc.DeskPort.display-native.desktop" \
      --replace-fail "$out/libexec/deskport-display" "$out/libexec/.deskport-display-wrapped"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "QT_QPA_PLATFORM=offscreen deskport --version";
  };

  passthru.tests.hostIsolation = runCommand "deskport-host-config-isolation" { } ''
    export HOME="$TMPDIR/home"
    export XDG_CONFIG_HOME="$TMPDIR/config"
    export CONFIGURATION_DIRECTORY="$TMPDIR/service-config"
    export SUNSHINE_MIGRATE_CONFIG=1
    mkdir -p "$HOME/.config/sunshine" "$XDG_CONFIG_HOME" "$CONFIGURATION_DIRECTORY"
    echo standalone > "$HOME/.config/sunshine/sentinel"
    ${finalAttrs.sessionHostLauncher} --version > "$out"
    grep -F 'Sunshine version:' "$out"
    test ! -e "$XDG_CONFIG_HOME/sunshine"
    test ! -e "$CONFIGURATION_DIRECTORY/sunshine"
    test ! -e "$XDG_CONFIG_HOME/DeskPort/host-runtime/sunshine/sentinel"
    test "$(cat "$HOME/.config/sunshine/sentinel")" = standalone
    mkdir -p "$TMPDIR/session"
    touch "$TMPDIR/session/host.conf"
    ${finalAttrs.sessionHostLauncher} "$TMPDIR/session/host.conf" --version >> "$out"
    test ! -e "$XDG_CONFIG_HOME/sunshine"
    test ! -e "$CONFIGURATION_DIRECTORY/sunshine"
    test ! -e "$TMPDIR/session/runtime/sunshine/sentinel"
  '';

  passthru.tests.headlessStartup = runCommand "deskport-headless-startup" { } ''
    export HOME="$TMPDIR/home"
    export XDG_CONFIG_HOME="$TMPDIR/config"
    export XDG_DATA_HOME="$TMPDIR/data"
    export XDG_CACHE_HOME="$TMPDIR/cache"
    export XDG_RUNTIME_DIR="$TMPDIR/runtime"
    export QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software SDL_VIDEODRIVER=dummy
    mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME" "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    status=0
    timeout --signal=TERM 6 ${finalAttrs.finalPackage}/bin/deskport --no-host-autostart > "$out" 2>&1 || status=$?
    test "$status" = 124
    ! grep -E 'QQmlApplicationEngine failed|is not installed|Cannot load library' "$out"
  '';

  meta = {
    description = "Remote desktop viewer and host with adaptive virtual workspaces";
    homepage = "https://github.com/keithxc/deskport";
    changelog = "https://github.com/keithxc/deskport/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.keithxc ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "deskport";
  };
})
