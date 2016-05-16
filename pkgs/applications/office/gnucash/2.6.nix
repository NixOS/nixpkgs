{ fetchurl, stdenv, pkgconfig, libxml2, libxslt, perl, perlPackages, gconf, guile
, intltool, glib, gtk, libofx, aqbanking, gwenhywfar, libgnomecanvas, goffice
, webkit, glibcLocales, gsettings_desktop_schemas, makeWrapper, dconf, file
, gettext, swig, slibGuile, enchant, bzip2, isocodes, libdbi, libdbiDrivers
, pango, gdk_pixbuf
}:

/*
Two cave-ats right now:
  1. HTML reports are broken
  2. You need to have dconf installed (GNOME3 should have it automatically,
     otherwise put it in environment.systemPackages), for settings
*/

stdenv.mkDerivation rec {
  name = "gnucash-2.6.9";

  src = fetchurl {
    url = "mirror://sourceforge/gnucash/${name}.tar.bz2";
    sha256 = "0iw25l1kv60cg6fd2vg11mcvzmjqnc5p9lp3rjy06ghkjfrn3and";
  };

  buildInputs = [
    # general
    intltool pkgconfig libxml2 libxslt glibcLocales file gettext swig enchant
    bzip2 isocodes
    # glib, gtk...
    glib gtk goffice webkit
    # gnome...
    dconf gconf libgnomecanvas gsettings_desktop_schemas
    # financial
    libofx aqbanking gwenhywfar
    # perl
    perl perlPackages.FinanceQuote perlPackages.DateManip
    # guile
    guile slibGuile
    # database backends
    libdbi libdbiDrivers
    # build
    makeWrapper
  ];

  patchPhase = ''
  patchShebangs ./src
  '';

  configureFlags = [
    "CFLAGS=-O3"
    "CXXFLAGS=-O3"
    "--enable-dbi"
    "--with-dbi-dbd-dir=${libdbiDrivers}/lib/dbd/"
    "--enable-ofx"
    "--enable-aqbanking"
  ];

  postInstall = ''
    # Auto-updaters don't make sense in Nix.
    rm $out/bin/gnc-fq-update

    #sed -i $out/bin/update-gnucash-gconf \
    #   -e 's|--config-source=[^ ]* --install-schema-file|--makefile-install-rule|'

    for prog in $(echo "$out/bin/"*)
    do
      # Don't wrap the gnc-fq-* scripts, since gnucash calls them as
      # "perl <script>', i.e. they must be Perl scripts.
      if [[ $prog =~ gnc-fq ]]; then continue; fi
      wrapProgram "$prog"                                               \
        --set SCHEME_LIBRARY_PATH "$SCHEME_LIBRARY_PATH"                \
        --prefix GUILE_LOAD_PATH ":" "$GUILE_LOAD_PATH"                 \
        --prefix PERL5LIB ":" "$PERL5LIB"                               \
        --set GCONF_CONFIG_SOURCE 'xml::~/.gconf'                       \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${name}" \
        --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"  \
        --prefix PATH ":" "$out/bin:${perl}/bin:${gconf}/bin"
    done

    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  # The following settings fix failures in the test suite. It's not required otherwise.
  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [ guile glib gtk pango gdk_pixbuf ];
  preCheck = "export GNC_DOT_DIR=$PWD/dot-gnucash";
  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Personal and small-business financial-accounting application";

    longDescription = ''
      GnuCash is personal and small-business financial-accounting software,
      freely licensed under the GNU GPL and available for GNU/Linux, BSD,
      Solaris, Mac OS X and Microsoft Windows.

      Designed to be easy to use, yet powerful and flexible, GnuCash allows
      you to track bank accounts, stocks, income and expenses.  As quick and
      intuitive to use as a checkbook register, it is based on professional
      accounting principles to ensure balanced books and accurate reports.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://www.gnucash.org/;

    maintainers = [ stdenv.lib.maintainers.peti stdenv.lib.maintainers.iElectric ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
