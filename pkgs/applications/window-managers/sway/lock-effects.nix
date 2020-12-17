{ stdenv, fetchFromGitHub,
  meson, ninja, pkgconfig, scdoc,
  wayland, wayland-protocols, libxkbcommon,
  cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock-effects";
  version = "v1.6-2";

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = version;
    sha256 = "0fs3c4liajgkax0a2pdc7117v1g9k73nv87g3kyv9wsnkfbbz534";
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
      Swaylock, with fancy effects
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnxlxnxx ];
  };
}
