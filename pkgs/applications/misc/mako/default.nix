{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc
, systemd, pango, cairo, gdk_pixbuf
, wayland, wayland-protocols
, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "mako";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "17azdc37xsbmx13fkfp23vg9lznrv9fh6nhagn64wdq3nhsxm3b6";
  };

  # to be removed with next release
  patches = [
    (fetchpatch {
      url = "https://github.com/emersion/mako/commit/ca8e763f06756136c534b1bbd2e5b536be6b1995.patch";
      sha256 = "09mi7nn2vwc69igxxc6y2m36n3snhsz0ady99yabhrzl17k4ryds";
    })
  ];

  nativeBuildInputs = [ meson ninja pkgconfig scdoc wayland-protocols ];
  buildInputs = [ systemd pango cairo gdk_pixbuf wayland ];

  mesonFlags = [
    "-Dicons=enabled" "-Dman-pages=enabled" "-Dzsh-completions=true"
  ];

  meta = with stdenv.lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = https://wayland.emersion.fr/mako/;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
