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
  version = "0-unstable-2026-09-04";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuswc";
    rev = "35d8564f9c4105df3e6f8f16ee323a55b3e027e6";
    hash = "sha256-ZMaqyXMsYnYjZkJr475RR6w2wlaJuK+QV94SRbaL2vc=";
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
