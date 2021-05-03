{ stdenv, fetchFromGitHub,
  meson, ninja, pkgconfig, scdoc,
  wayland, wayland-protocols, libxkbcommon,
  cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock-effects";
  version = "1.6-3";

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = "v${version}";
    sha256 = "sha256-71IX0fC4xCPP6pK63KtvDMb3KoP1rw/Iz3S7BgiLSpg=";
  };

  postPatch = ''
    sed -iE "s/version: '1\.3',/version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  mesonFlags = [
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
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
