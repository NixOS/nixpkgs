{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  wrapGAppsHook3,
  bash-completion,
  dbus,
  dbus-glib,
  fish,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk-layer-shell,
  gtk3,
  gvfs,
  json-glib,
  libgee,
  libhandy,
  libnotify,
  libpulseaudio,
  librsvg,
  meson,
  ninja,
  pkg-config,
  python3,
  scdoc,
  vala,
  wayland-scanner,
  xvfb-run,
  sassc,
  pantheon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "SwayNotificationCenter";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayNotificationCenter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kRawYbBLVx0ie4t7tChkA8QJShS83fUcGrJSKkxBy8Q=";
  };

  # build pkg-config is required to locate the native `scdoc` input
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    bash-completion
    # cmake # currently conflicts with meson
    fish
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    sassc
    scdoc
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    dbus-glib
    gdk-pixbuf
    glib
    gtk-layer-shell
    gtk3
    gvfs
    json-glib
    libgee
    libhandy
    libnotify
    libpulseaudio
    librsvg
    pantheon.granite
    # systemd # ends with broken permission
    wayland-scanner
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace src/functions.vala --replace "/usr/local/etc/xdg/swaync" "$out/etc/xdg/swaync"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${xvfb-run}/bin/xvfb-run swaync --version";
  };

  meta = {
    description = "Simple notification daemon with a GUI built for Sway";
    homepage = "https://github.com/ErikReider/SwayNotificationCenter";
    changelog = "https://github.com/ErikReider/SwayNotificationCenter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "swaync";
    maintainers = with lib.maintainers; [
      berbiche
      pedrohlc
    ];
  };
})
