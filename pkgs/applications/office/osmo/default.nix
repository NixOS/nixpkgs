{ stdenv, fetchurl, pkgconfig, gtk, libxml2, gettext, libical, libnotify
, libarchive, gtkspell, webkitgtk2, libgringotts }:

stdenv.mkDerivation rec {
  name = "osmo-${version}";
  version = "0.2.12";

  src = fetchurl {
    url = "mirror://sourceforge/osmo-pim/${name}.tar.gz";
    sha256 = "0y3bpsi18v3dxb3vsy0dr7cgf692g4p62l84hj9l2bpr2hbabgck";
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
