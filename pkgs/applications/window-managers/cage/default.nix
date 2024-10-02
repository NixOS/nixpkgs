{ lib, stdenv, fetchFromGitHub
, substituteAll
, meson, ninja, pkg-config, wayland-scanner, scdoc, makeWrapper
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon, xcbutilwm
, systemd, libGL, libX11, mesa
, xwayland ? null
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cage";
  version = "0.1.5-unstable-2024-07-29";

  src = fetchFromGitHub {
    owner = "cage-kiosk";
    repo = "cage";
    rev = "d3fb99d6654325ec46277cfdb589f89316bed701";
    hash = "sha256-WP0rWO9Wbs/09wTY8IlIUybnVUnwiNdXD9JgsoVG4rM=";
  };

  patches = [
    # TODO: Remove on next stable release.
    (substituteAll {
      src = ./inject-git-commit.patch;
      gitCommit = lib.substring 0 7 src.rev;
      gitBranch = "master";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon xcbutilwm
    mesa # for libEGL headers
    systemd libGL libX11
  ];

  postFixup = lib.optionalString wlroots.enableXWayland ''
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
