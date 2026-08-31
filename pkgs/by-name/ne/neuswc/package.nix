{
  fetchFromSourcehut,
  fontconfig,
  lib,
  libdrm,
  libinput,
  libxcb-util,
  libxcb-wm,
  libxkbcommon,
  meson,
  neuwld,
  ninja,
  nix-update-script,
  pixman,
  pkg-config,
  stdenv,
  udev,
  udevSupport ? true,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xwayland,
  xwaylandSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neuswc";
  version = "0-unstable-2026-03-19";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuswc";
    rev = "8a2d575859ae683ed7dc695b31c3c1dfa104242a";
    hash = "sha256-MJNoodnZGys+jTHP6QMLC1xViyfskZN2473uXyd2pYQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    libdrm
    libxkbcommon
    neuwld
    pixman
    wayland
    wayland-protocols
    wayland-scanner
    xwayland
  ]
  ++ lib.optionals udevSupport [
    libinput
    udev
  ]
  ++ lib.optionals xwaylandSupport [
    xwayland
    libxcb-util
    libxcb-wm
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = ''
      Fork of [swc](https://github.com/michaelforney/swc/) for [hevel
      window
      manager](https://git.sr.ht/~shrub900/neuswc/tree/main/hevel.derivelinux.org).
    '';
    homepage = "https://git.sr.ht/~shrub900/neuswc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ricardomaps
      yiyu
    ];
    platforms = lib.platforms.all;
  };
})
