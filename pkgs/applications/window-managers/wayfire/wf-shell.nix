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
  wayland-protocols,
  ddcutil,
  libxkbcommon,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-shell";
  version = "0.11.0";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-shell";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-1HNjCW0a4qygUW+/On5A19lsigkGDCHyFXEf3jvP22o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    libxkbcommon.dev
  ];

  buildInputs = [
    wayfire
    alsa-lib
    gtkmm4
    gtk4-layer-shell
    pulseaudio
    libdbusmenu
    ddcutil

    vala
    gobject-introspection

    wireplumber
    libdbusmenu
    libepoxy
    linux-pam
    pipewire.dev

    openssl

    inotify-tools
  ];

  patches = [
    (fetchpatch {
      name = "wf-shell_fix_meson";
      url = "https://github.com/WayfireWM/wf-shell/commit/8be3ff5671d51b9ea6455b82aff3b7ffad3ef48e.patch";
      hash = "sha256-0z5Nc/wylHIQgfbnLSbxL3hHpXp2gjLdiCEes8lHV6U=";
    })
  ];

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
