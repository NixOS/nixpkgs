{
  fetchFromSourcehut,
  fontconfig,
  lib,
  libdrm,
  libinput,
  libxcb,
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
  udevSupport ? stdenv.hostPlatform.isLinux,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xwayland,
  xwaylandSupport ? true,
  videoBackend ? "drm",
}:

assert lib.assertOneOf "videoBackend" videoBackend [
  "drm"
  "fb"
];
assert lib.assertMsg (
  xwaylandSupport -> videoBackend == "drm"
) "Enable the DRM video backend to use XWayland.";

stdenv.mkDerivation (finalAttrs: {
  pname = "neuswc";
  version = "0-unstable-2026-10-02";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuswc";
    rev = "d1ec3e24c7e0b7400dc5c0e4dfb7194e805a489d";
    hash = "sha256-6QOMs94SrW/RnYd8oZFgx5IBipDCH61cnEUdVNgknPo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    fontconfig
    libxkbcommon
    (neuwld.override { drmSupport = videoBackend == "drm"; })
    pixman
    wayland
    wayland-protocols
  ]
  ++ lib.optionals udevSupport [
    libinput
    udev
  ]
  ++ lib.optionals xwaylandSupport [
    xwayland
    libxcb
    libxcb-wm
  ]
  ++ lib.optional (videoBackend == "drm") libdrm;

  mesonFlags = [
    (lib.mesonEnable "xwayland" xwaylandSupport)
    (lib.mesonOption "video" videoBackend)
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
    platforms = lib.platforms.unix;
  };
})
