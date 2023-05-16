{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc
, wayland, wayland-protocols, cairo, gdk-pixbuf
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "swaybg";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaybg";
    rev = "v${version}";
    hash = "sha256-Qk5iGALlSVSzgBJzYzyLdLHhj/Zq1R4nFseACBmIBuA=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols cairo gdk-pixbuf ];

  mesonFlags = [
    "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  meta = with lib; {
    description = "Wallpaper tool for Wayland compositors";
<<<<<<< HEAD
    inherit (src.meta) homepage;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      A wallpaper utility for Wayland compositors, that is compatible with any
      Wayland compositor which implements the following Wayland protocols:
      wlr-layer-shell, xdg-output, and xdg-shell.
    '';
<<<<<<< HEAD
    license = licenses.mit;
    mainProgram = "swaybg";
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.linux;
=======
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
