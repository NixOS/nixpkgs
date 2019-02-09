{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, libxkbcommon, cairo, gdk_pixbuf, pam
}:

stdenv.mkDerivation rec {
  name = "swaylock-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    rev = version;
    sha256 = "093nv1y9wyg48rfxhd36qdljjry57v1vkzrlc38mkf6zvsq8j7wb";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk_pixbuf pam ];

  mesonFlags = [ "-Dswaylock-version=${version}"
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
