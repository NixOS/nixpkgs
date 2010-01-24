{ fetchurl, stdenv, pkgconfig, libxml2, gconf, glib, gtk
, libglade, libgnomeui, libgtkhtml, libgnomeprint, goffice, enchant
, gettext, intltool, perl, guile, slibGuile, swig, isocodes, bzip2
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gnucash-2.2.9";

  src = fetchurl {
    url = "http://ftp.at.gnucash.org/pub/gnucash/gnucash/sources/stable/${name}.tar.bz2";
    sha256 = "0sj83mmshx50122n1i3y782p4b54k37n7sb4vldmqmhwww32925i";
  };

  buildInputs = [
    pkgconfig libxml2 gconf glib gtk
    libglade libgnomeui libgtkhtml libgnomeprint goffice enchant
    gettext intltool perl guile slibGuile swig isocodes bzip2 makeWrapper
  ];

  preConfigure = ''
    # The `.gnucash' directory, used by the test suite.
    export GNC_DOT_DIR="$PWD/dot-gnucash"
    echo "\$GNC_DOT_DIR set to \`$GNC_DOT_DIR'"
  '';

  postInstall = ''
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog"                                       \
        --set SCHEME_LIBRARY_PATH "$SCHEME_LIBRARY_PATH"        \
        --prefix GUILE_LOAD_PATH ":" "$GUILE_LOAD_PATH"
    done
  '';

  doCheck = true;

  meta = {
    description = "GnuCash, a personal and small-business financial-accounting application";

    longDescription = ''
      GnuCash is personal and small-business financial-accounting software,
      freely licensed under the GNU GPL and available for GNU/Linux, BSD,
      Solaris, Mac OS X and Microsoft Windows.

      Designed to be easy to use, yet powerful and flexible, GnuCash allows
      you to track bank accounts, stocks, income and expenses.  As quick and
      intuitive to use as a checkbook register, it is based on professional
      accounting principles to ensure balanced books and accurate reports.
    '';

    license = "GPLv2+";

    homepage = http://www.gnucash.org/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
