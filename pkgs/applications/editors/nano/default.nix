{ stdenv, fetchurl, ncurses, gettext }:

stdenv.mkDerivation rec {
  name = "nano-${version}";
  version = "2.4.0";
  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "1gbm9bcv4k55y01r5q8a8a9s3yrrgq3z5jxxiij3wl404r8gnxjh";
  };
  buildInputs = [ ncurses gettext ];
  configureFlags = ''
    --sysconfdir=/etc
  '';

  meta = with stdenv.lib; {
    homepage = http://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ joachifm ];
    platforms = platforms.all;
  };
}
