{ fetchurl, stdenv, pkgconfig, makeWrapper, cmake, gtest
, boost, icu, libxml2, libxslt, gettext, swig, isocodes, gtk3, glibcLocales
, webkit, dconf, hicolor-icon-theme, libofx, aqbanking, gwenhywfar, libdbi
, libdbiDrivers, guile, perl, perlPackages
}:

let

  # Enable gnc-fq-* to run in command line.
  perlWrapper = stdenv.mkDerivation {
    name = perl.name + "-wrapper-for-gnucash";
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ perl ] ++ (with perlPackages; [ FinanceQuote DateManip ]);
    phases = [ "installPhase" ];
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
  name = "gnucash-${version}";
  version = "3.4";

  src = fetchurl {
    url = "mirror://sourceforge/gnucash/${name}.tar.bz2";
    sha256 = "1ms2wg4sh5gq3rpjmmnp85rh5nc9ahca1imxkvhz4d3yiwy8hm52";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper cmake gtest ];

  buildInputs = [
    boost icu libxml2 libxslt gettext swig isocodes gtk3 glibcLocales
    webkit dconf hicolor-icon-theme libofx aqbanking gwenhywfar libdbi
    libdbiDrivers guile
    perlWrapper perl
  ] ++ (with perlPackages; [ FinanceQuote DateManip ]);

  propagatedUserEnvPkgs = [ dconf ];

  # glib-2.58 deprecrated g_type_class_add_private
  # Should probably be removed next version bump
  CXXFLAGS = [ "-Wno-deprecated-declarations" ];

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
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share/gsettings-schemas/${name}" \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share" \
      --prefix PERL5LIB ":" "$PERL5LIB" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib dconf}/lib/gio/modules"
  '';

  # TODO: The following tests FAILED:
  #   61 - test-gnc-timezone (Failed)
  #   70 - test-load-c (Failed)
  #   71 - test-modsysver (Failed)
  #   72 - test-incompatdep (Failed)
  #   73 - test-agedver (Failed)
  #   77 - test-gnc-module-swigged-c (Failed)
  #   78 - test-gnc-module-load-deps (Failed)
  #   80 - test-gnc-module-scm-module (Failed)
  #   81 - test-gnc-module-scm-multi (Failed)
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/lib:$PWD/lib/gnucash:$PWD/lib/gnucash/test:$LD_LIBRARY_PATH
    export NIX_CFLAGS_LINK="-lgtest -lgtest_main"
  '';
  doCheck = false;

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
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;
  };
}
