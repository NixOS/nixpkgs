{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, libxkbcommon, cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    rev = version;
    sha256 = "0r95p4w11dwm5ra614vddz83r8j7z6gd120z2vcchy7m9b0f15kf";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "version: '1.4'" "version: '${version}'"
  '';

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  mesonFlags = [
    "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  meta = with stdenv.lib; {
    description = "Screen locker for Wayland";
    longDescription = ''
      swaylock is a screen locking utility for Wayland compositors.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
