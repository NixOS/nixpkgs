{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch2,
  aqbanking,
  boost,
  cmake,
  gettext,
  glib,
  glibcLocales,
  gobject-introspection,
  gtest,
  guile,
  gwenhywfar,
  icu,
  libdbi,
  libdbiDrivers,
  libofx,
  libsecret,
  libxml2,
  libxslt,
  makeWrapper,
  perlPackages,
  pkg-config,
  swig,
  webkitgtk_4_1,
  wrapGAppsHook3,
  python3,
}:
let
  py = python3.withPackages (
    ps: with ps; [
      pygobject3.out
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "gnucash";
  version = "5.11";

  # raw source code doesn't work out of box; fetchFromGitHub not usable
  src = fetchurl {
    url = "https://github.com/Gnucash/gnucash/releases/download/${version}/gnucash-${version}.tar.bz2";
    hash = "sha256-a6QjE6qqmbXwf/bk28WLM/v19L5ukRN2cB1lwm/U3r4=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    gobject-introspection
    makeWrapper
    wrapGAppsHook3
    pkg-config
  ];

  cmakeFlags = [
    "-DWITH_PYTHON=\"ON\""
    "-DPYTHON_SYSCONFIG_BUILD=\"$out\""
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
    libsecret
    libxml2
    libxslt
    swig
    webkitgtk_4_1
    py
  ]
  ++ (with perlPackages; [
    JSONParse
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
    # this patch makes gnucash exec the Finance::Quote wrapper directly
    ./0004-exec-fq-wrapper.patch
    # this patch adds in env vars to the Python lib that makes it able to find required resource files
    ./0005-python-env.patch
    # this patch backports a fix to remove unused includes causing build failures
    (fetchpatch2 {
      url = "https://github.com/Gnucash/gnucash/commit/940085a0172216240232551022686cea4da86096.patch?full_index=1";
      name = "0006-remove-unused-includes.patch";
      hash = "sha256-4CpBtKDkcT1HlOAHsbASxPiHKVpZ9ETWS3fXEupOl0Q=";
    })
  ];

  postPatch = ''
    substituteInPlace bindings/python/__init__.py \
      --subst-var-by gnc_dbd_dir "${libdbiDrivers}/lib/dbd" \
      --subst-var-by gsettings_schema_dir ${glib.makeSchemaPath "$out" "gnucash-${version}"};
  '';

  # this needs to be an environment variable and not a cmake flag to suppress
  # guile warning
  env.GUILE_AUTO_COMPILE = "0";

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
      # Needed with GCC 12 but breaks on darwin (with clang) or older gcc
      "-Wno-error=use-after-free"
    ]
  );

  doCheck = true;
  enableParallelChecking = true;
  checkTarget = "check";

  passthru.docs = stdenv.mkDerivation {
    pname = "gnucash-docs";
    inherit version;

    src = fetchFromGitHub {
      owner = "Gnucash";
      repo = "gnucash-docs";
      rev = version;
      hash = "sha256-uXpIAsucVUaAlqYTKfrfBg04Kb5Mza67l0ZU6fxkSUY=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [
      libxml2
      libxslt
    ];
  };

  preFixup = ''
    gappsWrapperArgs+=(
      # documentation
      --prefix XDG_DATA_DIRS : ${passthru.docs}/share
      # db drivers location
      --set GNC_DBD_DIR ${libdbiDrivers}/lib/dbd
      # gsettings schema location on Nix
      --set GSETTINGS_SCHEMA_DIR ${glib.makeSchemaPath "$out" "gnucash-${version}"}
    )
  '';

  # wrapGAppsHook3 would wrap all binaries including the cli utils which need
  # Perl wrapping
  dontWrapGApps = true;

  # We could not find the python entrypoint and somehow it is used from PATH,
  # so force to use the one with all dependencies
  # gnc-fq-* are cli utils written in Perl hence the extra wrapping
  postFixup = ''
    wrapProgram $out/bin/gnucash \
      --prefix PATH : ${lib.makeBinPath [ py ]} \
      "''${gappsWrapperArgs[@]}"
    wrapProgram $out/bin/gnucash-cli \
      --prefix PATH : ${lib.makeBinPath [ py ]} \
      "''${gappsWrapperArgs[@]}"

    wrapProgram $out/bin/finance-quote-wrapper \
      --prefix PERL5LIB : "${
        with perlPackages;
        makeFullPerlPath [
          JSONParse
          FinanceQuote
        ]
      }"

    chmod +x $out/share/gnucash/python/pycons/*.py
    patchShebangs $out/share/gnucash/python/pycons/*.py
  '';

  passthru.updateScript = ./update.sh;

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
    maintainers = with maintainers; [
      nevivurn
    ];
    platforms = platforms.unix;
    mainProgram = "gnucash";
  };
}
# TODO: investigate Darwin support
