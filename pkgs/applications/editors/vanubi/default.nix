{ stdenv, fetchurl, pkgconfig, vala, which, autoconf, automake
, libtool, glib, gtk3, gnome3, libwnck3, asciidoc, python3Packages }:

stdenv.mkDerivation rec {
  name = "vanubi-${version}";
  version = "0.0.14";

  src = fetchurl {
    url = "https://github.com/vanubi/vanubi/archive/v${version}.tar.gz";
    sha256 = "0cd45zm54j6xz1a31qllg2w7l77sncv7mrpfx9bjzdiqpmzsdypl";
  };

  buildInputs = [ pkgconfig vala which autoconf automake
                  libtool glib gtk3 libwnck3 asciidoc
                  gnome3.gtksourceview gnome3.vte python3Packages.pygments ];

  configureScript = "./autogen.sh";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://vanubi.github.io/vanubi;
    description = "Programming editor for GTK+ inspired by Emacs";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
