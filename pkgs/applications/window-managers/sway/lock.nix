{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, wlroots, libxkbcommon, cairo, pango, gdk_pixbuf, pam
}:

stdenv.mkDerivation rec {
  name = "swaylock-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    rev = version;
    sha256 = "1nqirrkkdhb6b2hc78ghi2yzblcx9jcgc9qwm1jvnk2iqwqbzclg";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols wlroots libxkbcommon cairo pango
    gdk_pixbuf pam
  ];

  mesonFlags = "-Dsway-version=${version}"; # TODO: Should probably be swaylock-version

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
