{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, libxkbcommon, cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    rev = version;
    sha256 = "sha256-VVGgidmSQWKxZNx9Cd6z52apxpxVfmX3Ut/G9kzfDcY=";
  };

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
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
