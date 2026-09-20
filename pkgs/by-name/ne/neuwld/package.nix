{
  doxygen,
  fetchFromSourcehut,
  fontconfig,
  lib,
  freetype,
  libdrm,
  meson,
  ninja,
  nix-update-script,
  pixman,
  pkg-config,
  stdenv,
  wayland,
  wayland-scanner,
  drmSupport ? true,
  waylandSupport ? true,
  documentationSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neuwld";
  version = "0-unstable-2026-08-13";

  src = fetchFromSourcehut {
    owner = "~shrub900";
    repo = "neuwld";
    rev = "554f827cadfdfcc276c709dbffa3b2b04c70cf7c";
    hash = "sha256-KAK4/TpNekaonN0yxi4/5mRdZL1uxYdGmwl41FRH5wU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ]
  ++ lib.optional (waylandSupport && drmSupport) wayland-scanner
  ++ lib.optional documentationSupport doxygen;

  buildInputs = [
    fontconfig
    pixman
    freetype
  ]
  ++ lib.optional drmSupport libdrm
  ++ lib.optional waylandSupport wayland;

  mesonFlags = [
    (lib.mesonEnable "wayland" waylandSupport)
    (lib.mesonEnable "drm" drmSupport)
    (lib.mesonEnable "doxygen" documentationSupport)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Drawing library that targets Wayland";
    homepage = "https://git.sr.ht/~shrub900/neuwld";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ricardomaps
      yiyu
    ];
    platforms = lib.platforms.unix;
  };
})
