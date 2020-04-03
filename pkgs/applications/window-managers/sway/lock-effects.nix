{ stdenv, fetchFromGitHub,
  meson, ninja, pkgconfig, scdoc,
  wayland, wayland-protocols, libxkbcommon,
  cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock-effects";
  version = "v1.6-0";

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = version;
    sha256 = "15lshqq3qj9m3yfac65hjcciaf9zdfh3ir7hgh0ach7gpi3rbk13";

  };

  postPatch = ''
    sed -iE "s/version: '1\.3',/version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  mesonFlags = [
    "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  meta = with stdenv.lib; {
    description = "Screen locker for Wayland";
    longDescription = ''
      swaylock-effects is a screen locking utility for Wayland compositors.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnxlxnxx ];
  };
}
