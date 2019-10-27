{ stdenv, fetchurl, pkgconfig, gtk3, libxml2, gettext, libical, libnotify
, libarchive, gspell, webkitgtk, libgringotts, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "osmo";
  version = "0.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/osmo-pim/${pname}-${version}.tar.gz";
    sha256 = "1gjd4w9jckfpqr9n0bw0w25h3qhfyzw1xvilh3hqdadfinwyal2v";
  };

  nativeBuildInputs = [ pkgconfig gettext wrapGAppsHook ];
  buildInputs = [ gtk3 libxml2 libical libnotify libarchive
    gspell webkitgtk libgringotts ];

  meta = with stdenv.lib; {
    description = "A handy personal organizer";
    homepage = http://clayo.org/osmo/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
