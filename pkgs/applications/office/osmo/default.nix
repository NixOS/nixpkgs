{ stdenv, fetchurl, pkgconfig, gtk3, libxml2, gettext, libical, libnotify
, libarchive, gtkspell3, webkitgtk, libgringotts, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "osmo-${version}";
  version = "0.4.0-1";

  src = fetchurl {
    url = "mirror://sourceforge/osmo-pim/${name}.tar.gz";
    sha256 = "fb454718e071c44bd360ce3e56cb29926cbf44a0d06ec738fa9b40fe3cbf8a33";
  };

  nativeBuildInputs = [ pkgconfig gettext wrapGAppsHook ];
  buildInputs = [ gtk3 libxml2 libical libnotify libarchive
    gtkspell3 webkitgtk libgringotts ];

  meta = with stdenv.lib; {
    description = "A handy personal organizer";
    homepage = http://clayo.org/osmo/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
