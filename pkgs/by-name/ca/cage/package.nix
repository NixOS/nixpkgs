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
  wlroots_0_20,
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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cage-kiosk";
    repo = "cage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NLoz11bfeZwesmwLmyytuB6/vSwIsnDWKzyAXFe+YZ0=";
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
    wlroots_0_20
    wayland
    wayland-protocols
    pixman
    libxkbcommon
    libxcb-wm
    libGL
    libx11
  ];

  postFixup = lib.optionalString wlroots_0_20.enableXWayland ''
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
