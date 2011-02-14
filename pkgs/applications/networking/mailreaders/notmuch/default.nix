{ fetchgit, stdenv, emacs, glib, gmime, pkgconfig, talloc, xapian }:

stdenv.mkDerivation rec {
  name = "notmuch-0.5-20110203";

  src = fetchgit {
    url = "git://notmuchmail.org/git/notmuch";
    rev = "62725a5b59625c164512465af5b3912396b61e8b";
    sha256 = "39b339f47cee1938d76e046cccfd7c3e5e5d37a578e40007a5d43adfc4cd41ce";
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
