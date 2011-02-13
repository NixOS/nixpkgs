{ fetchurl, stdenv, emacs, glib, gmime, pkgconfig, talloc, xapian }:

stdenv.mkDerivation rec {
  name = "notmuch-0.5";

  src = fetchurl {
    url = "http://notmuchmail.org/releases/${name}.tar.gz";
    sha256 = "c7eeb95c89c5b9cb22cc0b90abce5f923c20c982d607bf32829c989e905ff1a9";
  };

  buildInputs = [ emacs glib gmime pkgconfig talloc xapian ];

  meta = {
    description = "Notmuch -- The mail indexer";

    longDescription = "";

    license = "GPLv3";

    maintainers = [ stdenv.lib.maintainers.chaoflow ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
