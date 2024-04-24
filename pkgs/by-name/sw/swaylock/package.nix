{ lib, stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, libxkbcommon, cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    rev = "v${version}";
    hash = "sha256-ZsOLDqmkyhel8QAezdVZ51utruJrBZWqaZ7NzimXWQ4=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  mesonFlags = [
    "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  meta = with lib; {
    description = "Screen locker for Wayland";
    longDescription = ''
      swaylock is a screen locking utility for Wayland compositors.
      Important note: If you don't use the Sway module (programs.sway.enable)
      you need to set "security.pam.services.swaylock = {};" manually.
    '';
    inherit (src.meta) homepage;
    mainProgram = "swaylock";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
