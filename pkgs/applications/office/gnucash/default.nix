{ fetchurl, stdenv, pkgconfig, libxml2, gconf, glib, gtk
, libbonoboui, libgnomeui, libgtkhtml, gtkhtml, libgnomeprint, goffice, enchant
, gettext, intltool, perl, guile, slibGuile, swig, isocodes, bzip2
, makeWrapper }:

let
  name = "gnucash-2.4.7";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/gnucash/${name}.tar.bz2";
    sha256 = "eeb3b17f9081a544f8705db735df88ab3f468642a1d01552ea4e36bcb5b0730e";
  };

  buildInputs = [
    pkgconfig libxml2 gconf glib gtk
    libgnomeui libgtkhtml gtkhtml libgnomeprint goffice enchant
    gettext intltool perl guile slibGuile swig isocodes bzip2 makeWrapper
  ];

  /* The test suite isn't enabled at the moment, so this setting
     shouldn't be necessary.

  preConfigure = ''
    # The `.gnucash' directory, used by the test suite.
    export GNC_DOT_DIR="$PWD/dot-gnucash"
    echo "\$GNC_DOT_DIR set to \`$GNC_DOT_DIR'"
  '';
   */

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O2 CXXFLAGS=-O2 --disable-dbi";
  /* More flags to figure out:

       --enable-gtkmm            enable gtkmm gui
       --enable-ofx              compile with ofx support (needs LibOFX)
       --enable-aqbanking        compile with AqBanking support
       --enable-python-bindings  enable python bindings
   */

  NIX_LDFLAGS = "-rpath=${libgnomeui}/lib/libglade/2.0 -rpath=${libbonoboui}/lib/libglade/2.0 -rpath=${guile}/lib";

  postInstall = ''
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog"                                       \
        --set SCHEME_LIBRARY_PATH "$SCHEME_LIBRARY_PATH"        \
        --prefix GUILE_LOAD_PATH ":" "$GUILE_LOAD_PATH"         \
        --prefix PATH ":" "${gconf}/bin"
    done
  '';

  doCheck = false;
  /* The test suite fails as follows:

       /tmp/nix-build-y1mba6vkkscggnfigji57mwd0zhvnx1w-gnucash-2.4.7.drv-0/gnucash-2.4.7/src/import-export/test/.libs/lt-test-import-parse: error while loading shared libraries: libguile.so.17: cannot open shared object file: No such file or directory

  */

  enableParallelBuilding = true;

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

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
