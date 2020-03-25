{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, libxkbcommon, cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock-effects";
  version = "1.6-0";

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = "v${version}";
    sha256 = "11nap4xylq48pv7qaqxdcz3lbb2hyki8r996rzfzpw467mkxhsr5";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  mesonFlags = [
    "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  meta = with stdenv.lib; {
    description = "Screen locker with effects for Wayland";
    longDescription = ''
      swaylock-effects is a screen locking utility with built-in screenshots
      and image manipulation effects for Wayland compositors.
    '';
    homepage = "https://github.com/mortie/swaylock-effects";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bram209 ];
  };
}
