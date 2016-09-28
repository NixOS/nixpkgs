{ stdenv, fetchurl, pkgconfig, vala_0_26, which, autoconf, automake
, libtool, glib, gtk3, gnome3, libwnck3, asciidoc, python3Packages }:

stdenv.mkDerivation rec {
  name = "vanubi-${version}";
  version = "0.0.16";

  src = fetchurl {
    url = "https://github.com/vanubi/vanubi/archive/v${version}.tar.gz";
    sha256 = "145zxgaky5bcq5bxm4z7h0pvviq7k1nrgnf40q6nax6ik616ybjq";
  };

  buildInputs = [ pkgconfig vala_0_26 which autoconf automake
                  libtool glib gtk3 libwnck3 asciidoc
                  gnome3.gtksourceview gnome3.vte_290 python3Packages.pygments ];

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
