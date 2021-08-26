{ fetchurl, fetchpatch, lib, stdenv, pkg-config, makeWrapper, cmake, gtest
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
  version = "4.5";

  src = fetchurl {
    url = "mirror://sourceforge/gnucash/${pname}-${version}.tar.bz2";
    sha256 = "sha256-vB9IqEU0iKLp9rg7aGE6pVyuvk0pg0YL2sfghLRs/9w=";
  };

  patches = [
    # Fix build with GLib 2.68.
    (fetchpatch {
      url = "https://github.com/Gnucash/gnucash/commit/bbb4113a5a996dcd7bb3494e0be900b275b49a4f.patch";
      sha256 = "Pnvwoq5zutFw7ByduEEANiLM2J50WiXpm2aZ8B2MDMQ=";
    })
  ];

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

  # TODO: The following tests FAILED:
  #   70 - test-load-c (Failed)
  #   71 - test-modsysver (Failed)
  #   72 - test-incompatdep (Failed)
  #   73 - test-agedver (Failed)
  #   77 - test-gnc-module-swigged-c (Failed)
  #   78 - test-gnc-module-load-deps (Failed)
  #   80 - test-gnc-module-scm-module (Failed)
  #   81 - test-gnc-module-scm-multi (Failed)
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/lib:$PWD/lib/gnucash:$PWD/lib/gnucash/test''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
    export NIX_CFLAGS_LINK="-lgtest -lgtest_main"
  '';
  doCheck = false;

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

    maintainers = [ lib.maintainers.peti lib.maintainers.domenkozar ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}
