{ fetchurl, stdenv, pkgconfig, libxml2, gconf, glib, gtk, libgnomeui, libofx
, libgtkhtml, gtkhtml, libgnomeprint, goffice, enchant, gettext, libbonoboui
, intltool, perl, guile, slibGuile, swig, isocodes, bzip2, makeWrapper, libglade
, libgsf, libart_lgpl
}:

/* If you experience GConf errors when running GnuCash on NixOS, see
 * http://wiki.nixos.org/wiki/Solve_GConf_errors_when_running_GNOME_applications
 * for a possible solution.
 */

stdenv.mkDerivation rec {
  name = "gnucash-2.4.11";

  src = fetchurl {
    url = "mirror://sourceforge/gnucash/${name}.tar.bz2";
    sha256 = "0qbpgd6spclkmwryi66cih0igi5a6pmsnk41mmnscpfpz1mddhwk";
  };

  buildInputs = [
    pkgconfig libxml2 gconf glib gtk libgnomeui libgtkhtml gtkhtml
    libgnomeprint goffice enchant gettext intltool perl guile slibGuile
    swig isocodes bzip2 makeWrapper libofx libglade libgsf libart_lgpl
  ];

  # fix a problem with new intltool versions, taken from Gentoo
  patchPhase = "patch -p3 < ${./potfiles-skip.patch}";

  configureFlags = "CFLAGS=-O3 CXXFLAGS=-O3 --disable-dbi --enable-ofx";

  postInstall = ''
    sed -i $out/bin/update-gnucash-gconf                                \
       -e 's|--config-source=[^ ]* --install-schema-file|--makefile-install-rule|'
    for prog in "$out/bin/"*
    do
      wrapProgram "$prog"                                               \
        --set SCHEME_LIBRARY_PATH "$SCHEME_LIBRARY_PATH"                \
        --prefix GUILE_LOAD_PATH ":" "$GUILE_LOAD_PATH"                 \
        --prefix LD_LIBRARY_PATH ":" "${libgnomeui}/lib/libglade/2.0"   \
        --prefix LD_LIBRARY_PATH ":" "${libbonoboui}/lib/libglade/2.0"  \
        --set GCONF_CONFIG_SOURCE 'xml::~/.gconf'                       \
        --prefix PATH ":" "${gconf}/bin"                                \
        --suffix PATH ":" "$out/bin"
    done
  '';

  # The following settings fix failures in the test suite. It's not required otherwise.
  NIX_LDFLAGS = "-rpath=${guile}/lib -rpath=${glib}/lib";
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
