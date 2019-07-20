{ stdenv, autoreconfHook, fetchurl, dbus-glib, gtk2, pkgconfig, wordnet }:

stdenv.mkDerivation rec {
  name = "artha-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/artha/1.0.3/artha-1.0.3.tar.bz2";
    sha256 = "0qr4ihl7ma3cq82xi1fpzvf74mm9vsg0j035xvmcp3r6rmw2fycx";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ dbus-glib gtk2 wordnet ];

  patches = [
    ./gio-underlink.patch
  ];

  meta = with stdenv.lib; {
    description = "An offline thesaurus based on WordNet";
    homepage = http://artha.sourceforge.net;
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
