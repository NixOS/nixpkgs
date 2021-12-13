{ fetchurl, lib, stdenv, pkg-config, makeWrapper, cmake, gtest
, boost, icu, libxml2, libxslt, gettext, swig, isocodes, gtk3, glibcLocales
, webkitgtk, dconf, hicolor-icon-theme, libofx, aqbanking, gwenhywfar, libdbi
, libdbiDrivers, guile, perl, perlPackages
}:

let

  # Enable gnc-fq-* to run in command line.
  perlWrapper = stdenv.mkDerivation {
    name = perl.name + "-wrapper-for-gnucash";
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ perl ] ++ (with perlPackages; [ FinanceQuote DateManip ]);
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      for script in ${perl}/bin/*; do
        makeWrapper $script $out''${script#${perl}} \
          --prefix "PERL5LIB" ":" "$PERL5LIB"
      done
    '';
  };

in

stdenv.mkDerivation rec {
  pname = "gnucash";
  version = "4.8";

  src = fetchurl {
    url = "mirror://sourceforge/gnucash/${pname}-${version}.tar.bz2";
    sha256 = "04pbgx08lfm3l46ndd28ivq5yp3y6zgalbzgi2x8w5inhgzy9f0m";
  };

  nativeBuildInputs = [ pkg-config makeWrapper cmake gtest swig ];

  buildInputs = [
    boost icu libxml2 libxslt gettext isocodes gtk3 glibcLocales
    webkitgtk dconf libofx aqbanking gwenhywfar libdbi
    libdbiDrivers guile
    perlWrapper perl
  ] ++ (with perlPackages; [ FinanceQuote DateManip ]);

  propagatedUserEnvPkgs = [ dconf ];

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  # this patch disables test-gnc-timezone and test-gnc-datetime which fail due to nix datetime challenges
  patches = [ ./0001-changes.patch ];

  postPatch = ''
    patchShebangs .
  '';

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  postInstall = ''
    # Auto-updaters don't make sense in Nix.
    rm $out/bin/gnc-fq-update

    # Unnecessary in the release build.
    rm $out/bin/gnucash-valgrind

    wrapProgram "$out/bin/gnucash" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${pname}-${version}" \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share" \
      --prefix PERL5LIB ":" "$PERL5LIB" \
      --set GNC_DBD_DIR ${libdbiDrivers}/lib/dbd \
      --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  '';

  /*
  GNUcash's `make check` target does not define its prerequisites but expects them to have already been built.
  The list of targets below was built through trial and error based on failing tests.
  */
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/lib:$PWD/lib/gnucash:$PWD/lib/gnucash/test:$PWD/lib/gnucash/test/future''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
    export NIX_CFLAGS_LINK="-lgtest -lgtest_main"
    make test-scm-query test-split-register-copy-ops test-link-ofx test-import-backend test-import-account-matcher test-import-pending-matches test-qofquerycore test-import-map test-gnc-numeric test-gnc-rational test-gnc-int128 test-qofsession test-kvp-value test-gnc-guid test-numeric test-vendor test-job test-employee test-customer test-address test-business test-recurrence test-transaction-voiding test-transaction-reversal test-split-vs-account test-tokenizer test-aqb test-import-parse test-link-module-tax-us test-dynload test-agedver test-incompatdep test-modsysver test-load-c test-gnc-path-util test-xml2-is-file test-load-example-account test-query test-querynew test-lots test-group-vs-book test-account-object test-engine test-qof test-commodities test-object test-guid test-load-engine test-userdata-dir-invalid-home test-userdata-dir test-resolve-file-path test-gnc-glib-utils test-sqlbe test-column-types test-backend-dbi test-xml-transaction test-xml-pricedb test-xml-commodity test-xml-account test-string-converters test-load-backend test-kvp-frames test-dom-converters1 test-autoclear test-sx test-print-parse-amount gncmod-futuremodsys
  '';
  doCheck = true;

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

    license = lib.licenses.gpl2Plus;

    homepage = "http://www.gnucash.org/";

    maintainers = [ lib.maintainers.domenkozar ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}
