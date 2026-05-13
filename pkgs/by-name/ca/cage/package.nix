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
    # and https://github.com/cage-kiosk/cage/pull/464
    # to fix https://github.com/cage-kiosk/cage/issues/456
    # and https://github.com/cage-kiosk/cage/pull/463
    # remove on next release
    (fetchpatch {
      url = "https://github.com/cage-kiosk/cage/compare/f9626f79519f8ee22d7bb0c3880a66791d82f923..73bf1c8bd6bbeabe2c05cee8a8a55edbd45e7982.patch";
      hash = "sha256-zCrmv90CWbsPuBTxjLT+m0WmmkWiJj7b786Krbm4mEs=";
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
