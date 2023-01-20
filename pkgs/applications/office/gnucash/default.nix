{ lib
, stdenv
, fetchurl
, aqbanking
, boost
, cmake
, gettext
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
, perlPackages
, pkg-config
, swig
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnucash";
  version = "4.12";

  # raw source code doesn't work out of box; fetchFromGitHub not usable
  src = fetchurl {
    url = "https://github.com/Gnucash/gnucash/releases/download/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-zIwFGla4u0M1ZtbiiQ31nz2JWjlcjPUkbBtygQLOEK4=";
  };

  nativeBuildInputs = [
    cmake
    gettext
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
    pkg-config
    swig
    webkitgtk
  ]
  ++ (with perlPackages; [
    DateManip
    FinanceQuote
    perl
  ]);

  patches = [
    # this patch disables test-gnc-timezone and test-gnc-datetime which fail due to nix datetime challenges
    ./0001-disable-date-and-time-tests.patch
    # this patch prevents the building of gnc-fq-update, a utility which updates the GnuCash cli utils
    ./0002-disable-gnc-fq-update.patch
    # this patch prevents the building of gnucash-valgrind
    ./0003-remove-valgrind.patch
  ];

  # this needs to be an environment variable and not a cmake flag to suppress
  # guile warning
  GUILE_AUTO_COMPILE="0";

  # `make check` target does not define its prerequisites but expects them to
  # have already been built.  The list of targets below was built through trial
  # and error based on failing tests.
  doCheck = true;
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
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # db drivers location
      --set GNC_DBD_DIR ${libdbiDrivers}/lib/dbd
      # gnome settings schemas location on Nix
      --set GSETTINGS_SCHEMA_DIR ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    )
  '';

  # wrapGAppsHook would wrap all binaries including the cli utils which need
  # Perl wrapping
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
    homepage = "https://www.gnucash.org/";
    description = "Free software for double entry accounting";
    longDescription = ''
      GnuCash is personal and small-business financial-accounting software,
      freely licensed under the GNU GPL and available for GNU/Linux, BSD,
      Solaris, Mac OS X and Microsoft Windows.

      Designed to be easy to use, yet powerful and flexible, GnuCash allows you
      to track bank accounts, stocks, income and expenses. As quick and
      intuitive to use as a checkbook register, it is based on professional
      accounting principles to ensure balanced books and accurate reports.

      Some interesting features:

      - Double-Entry Accounting
      - Stock/Bond/Mutual Fund Accounts
      - Small-Business Accounting
      - Reports, Graphs
      - QIF/OFX/HBCI Import, Transaction Matching
      - Scheduled Transactions
      - Financial Calculations
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ domenkozar AndersonTorres rski ];
    platforms = platforms.unix;
  };
}
# TODO: investigate Darwin support
