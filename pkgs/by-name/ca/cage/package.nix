{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  scdoc,
  makeWrapper,
  wlroots_0_19,
  wayland,
  wayland-protocols,
  pixman,
  libxkbcommon,
  libxcb-wm,
  libGL,
  libx11,
  xwayland ? null,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cage";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cage-kiosk";
    repo = "cage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P9MhIl2YIE2hwT5Yr0Cpes5S12evb0aj9oOPLeehkw0=";
  };

  patches = [
    # backport of https://github.com/cage-kiosk/cage/pull/461
    # to fix https://github.com/cage-kiosk/cage/issues/456
    # remove on next release
    (fetchpatch {
      url = "https://github.com/cage-kiosk/cage/commit/832e88b0c964a324bb09c7af02ed0650b73dfb9b.patch";
      hash = "sha256-8dyJL46xXGkw3pF9uskX8H72s0hUO1BhU2UMaoEwz4U=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    scdoc
    makeWrapper
  ];

  buildInputs = [
    wlroots_0_19
    wayland
    wayland-protocols
    pixman
    libxkbcommon
    libxcb-wm
    libGL
    libx11
  ];

  postFixup = lib.optionalString wlroots_0_19.enableXWayland ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  # Tests Cage using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.cage;

  meta = {
    description = "Wayland kiosk that runs a single, maximized application";
    homepage = "https://www.hjdskes.nl/projects/cage/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "cage";
  };
})
