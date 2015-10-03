{ stdenv, fetchurl, pkgconfig, gtk, libxml2, gettext, libical, libnotify
, libarchive, gtkspell, webkitgtk2, libgringotts }:

stdenv.mkDerivation rec {
  name = "osmo-${version}";
  version = "0.2.14";

  src = fetchurl {
    url = "mirror://sourceforge/osmo-pim/${name}.tar.gz";
    sha256 = "0vaayrmyiqn010gr11drmhkkg8fkxdmla3gwj9v3zvp5x44kab05";
  };

  buildInputs = [ pkgconfig gtk libxml2 gettext libical libnotify libarchive
    gtkspell webkitgtk2 libgringotts ];

  meta = with stdenv.lib; {
    description = "A handy personal organizer";
    homepage = http://clayo.org/osmo/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
