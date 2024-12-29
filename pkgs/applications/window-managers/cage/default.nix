{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland-scanner, scdoc, makeWrapper
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon, xcbutilwm
, systemd, libGL, libX11, mesa
, xwayland ? null
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cage";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    rev = "v${version}";
    hash = "sha256-Suq14YRw/MReDRvO/TQqjpZvpzAEDnHUyVbQj0BPT4c=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon xcbutilwm
    mesa # for libEGL headers
    systemd libGL libX11
  ];

  mesonFlags = [ "-Dxwayland=${lib.boolToString (xwayland != null)}" ];

  postFixup = lib.optionalString (xwayland != null) ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  # Tests Cage using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.cage;

  meta = with lib; {
    description = "Wayland kiosk that runs a single, maximized application";
    homepage    = "https://www.hjdskes.nl/projects/cage/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
    mainProgram = "cage";
  };
}
