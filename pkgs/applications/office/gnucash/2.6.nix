{ fetchurl, fetchpatch, stdenv, intltool, pkgconfig, file, makeWrapper
, libxml2, libxslt, perl, perlPackages, gconf, guile
, glib, gtk2, libofx, aqbanking, gwenhywfar, libgnomecanvas, goffice
, webkit, glibcLocales, gsettings-desktop-schemas, dconf
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
  name = "gnucash-2.6.18-1";

  src = fetchurl {
    url = "mirror://sourceforge/gnucash/${name}.tar.bz2";
    sha256 = "1794qi7lkn1kbnhzk08wawacfcphbln3ngdl3q0qax5drv7hnwv8";
  };

  patches = [
    (fetchpatch {
     sha256 = "11nlf9j7jm1i37mfcmmnkplxr3nlf257fxd01095vd65i2rn1m8h";
     name = "fix-brittle-test.patch";
     url = "https://github.com/Gnucash/gnucash/commit/42ac55e03a1a84739f4a5b7a247c31d91c0adc4a.patch";
    })
  ];

  nativeBuildInputs = [ intltool pkgconfig file makeWrapper ];

  buildInputs = [
    # general
    libxml2 libxslt glibcLocales gettext swig enchant
    bzip2 isocodes
    # glib, gtk...
    glib gtk2 goffice webkit
    # gnome...
    dconf gconf libgnomecanvas gsettings-desktop-schemas
    # financial
    libofx aqbanking gwenhywfar
    # perl
    perl perlPackages.FinanceQuote perlPackages.DateManip
    # guile
    guile slibGuile
    # database backends
    libdbi libdbiDrivers
  ];

  postPatch = ''
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
        --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"  \
        --prefix PATH ":" "$out/bin:${stdenv.lib.makeBinPath [ perl gconf ]}"
    done

    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  # The following settings fix failures in the test suite. It's not required otherwise.
  LD_LIBRARY_PATH = stdenv.lib.makeLibraryPath [ guile glib gtk2 pango gdk_pixbuf ];
  preCheck = "export GNC_DOT_DIR=$PWD/dot-gnucash";
  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Personal and small-business financial-accounting application";

    longDescription = ''
      GnuCash is personal and small-business financial-accounting software,
      freely licensed under the GNU GPL and available for GNU/Linux, BSD,
      Solaris, macOS and Microsoft Windows.

      Designed to be easy to use, yet powerful and flexible, GnuCash allows
      you to track bank accounts, stocks, income and expenses.  As quick and
      intuitive to use as a checkbook register, it is based on professional
      accounting principles to ensure balanced books and accurate reports.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = http://www.gnucash.org/;

    maintainers = [ stdenv.lib.maintainers.peti stdenv.lib.maintainers.domenkozar ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
