{ fetchurl
, lib
, stdenv
, aqbanking
, boost
, cmake
, glib
, glibcLocales
, gtest
, guile
, gwenhywfar
, icu
, libdbi
, libdbiDrivers
, libofx
, libxml2
, libxslt
, makeWrapper
, perl
, perlPackages
, pkg-config
, swig
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnucash";
  version = "4.9";

  src = fetchurl {
    url = "https://github.com/Gnucash/gnucash/releases/download/${version}/gnucash-${version}.tar.bz2";
    sha256 = "0bdpzb0wc9bjph5iff7133ppnkcqzfd10yi2qagij4mpq4q1qmcs";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    aqbanking
    boost
    glib
    glibcLocales
    gtest
    guile
    gwenhywfar
    icu
    libdbi
    libdbiDrivers
    libofx
    libxml2
    libxslt
    perl
    pkg-config
    swig
    webkitgtk
  ] ++ (with perlPackages; [ FinanceQuote DateManip ]);

  patches = [
    # this patch disables test-gnc-timezone and test-gnc-datetime which fail due to nix datetime challenges
    ./0001-disable-date-and-time-tests.patch
    # this patch prevents the building of gnc-fq-update, a utility which updates the GnuCash cli utils
    ./0002-disable-gnc-fq-update.patch
    # this patch prevents the building of gnucash-valgrind
    ./0003-remove-valgrind.patch
  ];

  preConfigure = ''
    export GUILE_AUTO_COMPILE=0 # this needs to be an env variable and not a cmake flag to suppress guile warning
  '';

  doCheck = true;

  /*
    GNUcash's `make check` target does not define its prerequisites but expects them to have already been built.
    The list of targets below was built through trial and error based on failing tests.
  */
  preCheck = ''
    make \
      test-account-object \
      test-address \
      test-agedver \
      test-app-utils \
      test-aqb \
      test-autoclear \
      test-backend-dbi \
      test-business \
      test-column-types \
      test-commodities \
      test-customer \
      test-dom-converters1 \
      test-dynload \
      test-employee \
      test-engine \
      test-exp-parser \
      test-gnc-glib-utils \
      test-gnc-guid \
      test-gnc-int128 \
      test-gnc-numeric \
      test-gnc-path-util \
      test-gnc-rational \
      test-group-vs-book \
      test-guid \
      test-import-account-matcher \
      test-import-backend \
      test-import-map \
      test-import-parse \
      test-import-pending-matches \
      test-incompatdep \
      test-job \
      test-kvp-frames \
      test-kvp-value \
      test-link-module-tax-us \
      test-link-ofx \
      test-load-backend \
      test-load-c \
      test-load-engine \
      test-load-example-account \
      test-load-xml2 \
      test-lots \
      test-modsysver \
      test-numeric \
      test-object \
      test-print-parse-amount \
      test-qof \
      test-qofquerycore \
      test-qofsession \
      test-query \
      test-querynew \
      test-recurrence \
      test-resolve-file-path \
      test-scm-query \
      test-scm-query-string \
      test-split-register-copy-ops \
      test-split-vs-account \
      test-sqlbe \
      test-string-converters \
      test-sx \
      test-tokenizer \
      test-transaction-reversal \
      test-transaction-voiding \
      test-userdata-dir \
      test-userdata-dir-invalid-home \
      test-vendor \
      test-xml-account \
      test-xml-commodity \
      test-xml-pricedb \
      test-xml-transaction \
      test-xml2-is-file

      export LD_LIBRARY_PATH="$PWD/lib:$PWD/lib/gnucash:$PWD/lib/gnucash/test:$PWD/lib/gnucash/test/future"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set GNC_DBD_DIR ${libdbiDrivers}/lib/dbd                                      # specify where db drivers are
      --set GSETTINGS_SCHEMA_DIR ${glib.makeSchemaPath "$out" "${pname}-${version}"}  # specify where nix puts the gnome settings schemas
    )
  '';

  # wrapGAppsHook would wrap all binaries including the cli utils which need Perl wrapping
  dontWrapGApps = true;

  # gnucash is wrapped using the args constructed for wrapGAppsHook.
  # gnc-fq-* are cli utils written in Perl hence the extra wrapping
  postFixup = ''
    wrapProgram $out/bin/gnucash "''${gappsWrapperArgs[@]}"

    for file in $out/bin/gnc-fq-check $out/bin/gnc-fq-dump $out/bin/gnc-fq-helper; do
      wrapProgram $file \
      --prefix PERL5LIB : "${with perlPackages; makeFullPerlPath [ DateManip FinanceQuote ]}"
    done
  '';

  meta = with lib; {
    description = "Personal and small business double entry accounting application.";
    longDescription = ''
      Designed to be easy to use, yet powerful and flexible, GnuCash allows you to track bank accounts, stocks, income and expenses.
      As quick and intuitive to use as a checkbook register, it is based on professional accounting principles to ensure balanced books and accurate reports.
    '';

    homepage = "https://www.gnucash.org/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.domenkozar ];
    platforms = platforms.linux;
  };
}
