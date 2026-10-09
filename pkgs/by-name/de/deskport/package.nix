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
  version = "0.7.0-rc.2";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "keithxc";
    repo = "deskport";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pQFeg3b+E3KxdS1EM/wmO8P1Uxyo1QLXdg6EpcWsPI4=";
  };

  deskportCore = fetchFromGitHub {
    owner = "keithxc";
    repo = "deskport-core";
    rev = "108ca7d24c023b443687971690b1066427012608";
    hash = "sha256-lkHEw7jKpRm+JMSZZxsRbr2Q7Lv7Per/cBfUwhHTru4=";
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

  preConfigure = ''
    # With strictDeps, qmake does not discover target-side Wayland modules.
    export QMAKEPATH="${lib.getDev qt6.qtwayland}:$QMAKEPATH"
  '';

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

  passthru.tests.packageStartup =
    runCommand "deskport-package-startup"
      {
        nativeBuildInputs = [ python3 ];
      }
      ''
        mkdir -p package/usr
        ln -s ${finalAttrs.finalPackage}/bin package/usr/bin
        ln -s ${finalAttrs.finalPackage}/libexec package/usr/libexec
        ln -s ${finalAttrs.finalPackage}/bin/deskport package/AppRun
        python3 ${finalAttrs.src}/scripts/check-linux-package.py "$PWD/package" ${finalAttrs.version}
        touch "$out"
      '';

  meta = {
    description = "Remote desktop viewer and host with adaptive virtual workspaces";
    longDescription = ''
      DeskPort combines a Moonlight-based remote desktop viewer with a private
      Sunshine host. It supports background sessions, adaptive virtual desktop
      sizing, display layout restoration, per-device settings and clipboard
      sharing between approved desktop peers. Its HTTPS browser client streams
      video, audio and input over WebRTC, with time-based code sign-in and
      optional remembered browsers. Hosting requires a graphical session and
      separately configured capture, input-device and network permissions.
    '';
    homepage = "https://github.com/keithxc/deskport";
    changelog = "https://github.com/keithxc/deskport/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.keithxc ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "deskport";
  };
})
