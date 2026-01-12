{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "gnucash";
  version = "5.14";

  # raw source code doesn't work out of box; fetchFromGitHub not usable
  src = fetchurl {
    url = "https://github.com/Gnucash/gnucash/releases/download/${finalAttrs.version}/gnucash-${finalAttrs.version}.tar.bz2";
    hash = "sha256-DG/SAhTahqmgRDNZ97YtmivU7YAv1oCFPaS3V6NxrJE=";
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

  env = {
    # https://github.com/Gnucash/gnucash/commit/e680a87a66b8ec17132f186e222cbc94ad52b3d0
    GNC_DBD_DIR = "${libdbiDrivers}/lib/dbd";

    # this needs to be an environment variable and not a cmake flag to suppress
    # guile warning
    GUILE_AUTO_COMPILE = "0";

    NIX_CFLAGS_COMPILE = toString (
      lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12") [
        # Needed with GCC 12 but breaks on darwin (with clang) or older gcc
        "-Wno-error=use-after-free"
      ]
    );
  };

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
  ];

  postPatch = ''
    find . -name '._*' -type f -delete

    substituteInPlace bindings/python/__init__.py \
      --subst-var-by gnc_dbd_dir "${libdbiDrivers}/lib/dbd" \
      --subst-var-by gsettings_schema_dir ${glib.makeSchemaPath "$out" "gnucash-${finalAttrs.version}"};
  '';

  doCheck = true;
  enableParallelChecking = true;
  checkTarget = "check";

  passthru = {
    docs = stdenv.mkDerivation {
      pname = "gnucash-docs";
      inherit (finalAttrs) version;

      src = fetchFromGitHub {
        owner = "Gnucash";
        repo = "gnucash-docs";
        tag = finalAttrs.version;
        hash = "sha256-KaUkpqBSQnrWR/ynZC6DuUUnbCURxwFBVg+f4HVwy3Q=";
      };

      nativeBuildInputs = [ cmake ];
      buildInputs = [
        libxml2
        libxslt
      ];
    };

    updateScript = ./update.sh;
  };

  preFixup = ''
    gappsWrapperArgs+=(
      # documentation
      --prefix XDG_DATA_DIRS : ${finalAttrs.passthru.docs}/share
      # db drivers location
      --set GNC_DBD_DIR ${libdbiDrivers}/lib/dbd
      # gsettings schema location on Nix
      --set GSETTINGS_SCHEMA_DIR ${glib.makeSchemaPath "$out" "gnucash-${finalAttrs.version}"}
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

  meta = {
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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nevivurn
      ryand56
    ];
    platforms = lib.platforms.unix;
    mainProgram = "gnucash";
  };
})
# TODO: investigate Darwin support
