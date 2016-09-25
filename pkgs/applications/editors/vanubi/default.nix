{ stdenv, fetchurl, pkgconfig, which, autoconf, automake
, libtool, gnome3, libwnck3, asciidoc, python3Packages }:

stdenv.mkDerivation rec {
  name = "vanubi-${version}";
  version = "0.0.16";

  src = fetchurl {
    url = "https://github.com/vanubi/vanubi/archive/v${version}.tar.gz";
    sha256 = "145zxgaky5bcq5bxm4z7h0pvviq7k1nrgnf40q6nax6ik616ybjq";
  };

  buildInputs = [ pkgconfig which autoconf automake
                  libtool libwnck3 asciidoc python3Packages.pygments
                ] ++ (with gnome3; [ gtksourceview glib gtk3 vte_290 vala ]);

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
