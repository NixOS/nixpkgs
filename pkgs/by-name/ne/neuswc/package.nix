{
  buildPackages,
  fetchFromSourcehut,
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
  wayland,
  wayland-protocols,
  wayland-scanner,
  xwayland,
  xwaylandSupport ? videoBackend == "drm",
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

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libinput
    libxkbcommon
    (neuwld.override { drmSupport = videoBackend == "drm"; })
    pixman
    udev
    wayland
    wayland-protocols
  ]
  ++ lib.optionals xwaylandSupport [
    xwayland
    libxcb
    libxcb-wm
  ]
  ++ lib.optional (videoBackend == "drm") libdrm;

  # Required by swc.pc
  propagatedBuildInputs = [ wayland ];

  postPatch = ''
    # Cursor data generator runs on the build machine, where the host-only
    # project arguments such as -D_GNU_SOURCE do not apply
    substituteInPlace cursor/meson.build \
      --replace-fail "executable('convert_cont', 'convert_font.c')" \
                     "executable('convert_cont', 'convert_font.c', c_args: '-D_GNU_SOURCE', native: true)"
  ''
  # Xwayland is spawned through PATH, which may not contain it at runtime
  + lib.optionalString xwaylandSupport ''
    substituteInPlace libswc/xserver.c \
      --replace-fail 'execlp("Xwayland",' 'execlp("${lib.getExe xwayland}",'
  '';

  mesonFlags = [
    (lib.mesonEnable "xwayland" xwaylandSupport)
    (lib.mesonOption "video" videoBackend)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Fork of the swc Wayland compositor library used by hevel";
    homepage = "https://git.sr.ht/~shrub900/neuswc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ricardomaps
      yiyu
    ];
    platforms = lib.platforms.linux;
  };
})
