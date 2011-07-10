{ fetchurl, stdenv, pkgconfig, libxml2, gconf, glib, gtk
, libbonoboui, libgnomeui, libgtkhtml, gtkhtml, libgnomeprint, goffice, enchant
, gettext, intltool, perl, guile, slibGuile, swig, isocodes, bzip2
, makeWrapper }:

# TODO: Fix the gconf issue. The following posting might be the missing clue:
# <http://osdir.com/ml/linux.distributions.nixos/2007-09/msg00003.html>.

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

  NIX_LDFLAGS = "-rpath=${libgnomeui}/lib/libglade/2.0 -rpath=${libbonoboui}/lib/libglade/2.0 -rpath=${guile}/lib";

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O2 CXXFLAGS=-O2 --disable-dbi";
  /* More flags to figure out:

       --enable-gtkmm            enable gtkmm gui
       --enable-ofx              compile with ofx support (needs LibOFX)
       --enable-aqbanking        compile with AqBanking support
       --enable-python-bindings  enable python bindings
   */

  postInstall = ''
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog"                                       \
        --set SCHEME_LIBRARY_PATH "$SCHEME_LIBRARY_PATH"        \
        --prefix GUILE_LOAD_PATH ":" "$GUILE_LOAD_PATH"         \
        --prefix PATH ":" "${gconf}/bin"
    done
  '';

  preCheck = "export GNC_DOT_DIR=$PWD/dot-gnucash";
  doCheck = true;
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
