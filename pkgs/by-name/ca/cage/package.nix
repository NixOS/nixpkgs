{
  lib,
  stdenv,
  fetchFromGitHub,
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
  xcbutilwm,
  libGL,
  libX11,
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
    xcbutilwm
    libGL
    libX11
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
