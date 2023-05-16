{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland-scanner, scdoc, makeWrapper
<<<<<<< HEAD
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon, xcbutilwm
=======
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, systemd, libGL, libX11, mesa
, xwayland ? null
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cage";
<<<<<<< HEAD
  version = "0.1.5";
=======
  version = "0.1.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Suq14YRw/MReDRvO/TQqjpZvpzAEDnHUyVbQj0BPT4c=";
=======
    sha256 = "0vm96gxinhy48m3x9p1sfldyd03w3gk6iflb7n9kn06j1vqyswr6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc makeWrapper ];

  buildInputs = [
<<<<<<< HEAD
    wlroots wayland wayland-protocols pixman libxkbcommon xcbutilwm
=======
    wlroots wayland wayland-protocols pixman libxkbcommon
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    description = "A Wayland kiosk that runs a single, maximized application";
    homepage    = "https://www.hjdskes.nl/projects/cage/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
<<<<<<< HEAD
    mainProgram = "cage";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
