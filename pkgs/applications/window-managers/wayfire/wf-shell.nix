{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayfire,
  alsa-lib,
  gtkmm4,
  gtk4-layer-shell,
  pulseaudio,
  pipewire,
  wireplumber,
  libdbusmenu,
  libepoxy,
  linux-pam,
  vala,
  gobject-introspection,
  openssl,
  inotify-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-shell";
  version = "0.11.0-unstable-2026-02-21";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-shell";
    rev = "6057938099a2abe829fd3f8a3f466889327d92a3";
    fetchSubmodules = true;
    hash = "sha256-dMetnyr8ntmJybPialubLwsrv3ST7utWmnIY05u6t/4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    vala
    gobject-introspection
  ];

  buildInputs = [
    wayfire
    alsa-lib
    gtkmm4
    gtk4-layer-shell
    pulseaudio
    wireplumber
    libdbusmenu
    libepoxy
    linux-pam
    pipewire.dev

    #wf-json
    openssl

    #wayland-logout
    inotify-tools
  ];

  postPatch = ''
    substituteInPlace data/meson.build \
      --replace-fail "/etc/pam.d/" "etc/pam.d"
  '';

  meta = {
    homepage = "https://github.com/WayfireWM/wf-shell";
    description = "GTK3-based panel for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
  };
})
