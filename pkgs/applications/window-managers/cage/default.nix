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
  wlroots,
  wayland,
  wayland-protocols,
  pixman,
  libxkbcommon,
  xcbutilwm,
  systemd,
  libGL,
  libX11,
  xwayland ? null,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "cage";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cage-kiosk";
    repo = "cage";
    rev = "refs/tags/v${version}";
    hash = "sha256-2SFtz62z0EF8cpFTC6wGi125MD4a5mkXqP/C+7fH+3g=";
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
    wlroots
    wayland
    wayland-protocols
    pixman
    libxkbcommon
    xcbutilwm
    systemd
    libGL
    libX11
  ];

  postFixup = lib.optionalString wlroots.enableXWayland ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  # Tests Cage using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.cage;

  meta = with lib; {
    description = "Wayland kiosk that runs a single, maximized application";
    homepage = "https://www.hjdskes.nl/projects/cage/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
    mainProgram = "cage";
  };
}
