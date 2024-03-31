{
  # build tools
  stdenv,
  autoreconfHook,
  makeWrapper,
  pkg-config,

  # fetchers
  fetchFromGitHub,
  fetchpatch,
  fetchurl,

  # build inputs
  bison,
  brotli,
  coreutils,
  cunit,
  cyrus_sasl,
  fig2dev,
  flex,
  icu,
  jansson,
  lib,
  libbsd,
  libcap,
  libchardet,
  libical,
  libmysqlclient,
  libsrs2,
  libuuid,
  libxml2,
  nghttp2,
  openssl,
  pcre2,
  perl,
  postgresql,
  rsync,
  shapelib,
  sqlite,
  unixtools,
  valgrind,
  wslay,
  xapian,
  zlib,

  # test utils
  testers,
  cyrus-imapd,

  # feature flags
  enableAutoCreate ? true,
  enableBackup ? true,
  enableCalalarmd ? true,
  enableHttp ? true,
  enableIdled ? true,
  enableJMAP ? true,
  enableMurder ? true,
  enableNNTP ? false,
  enableReplication ? true,
  enableSrs ? true,
  enableUnitTests ? true,
  enableXapian ? true,

  withLibcap ? true,
  withMySQL ? false,
  withOpenssl ? true,
  withPgSQL ? false,
  withSQLite ? true,
  withZlib ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cyrus-imapd";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "cyrusimap";
    repo = "cyrus-imapd";
    rev = "refs/tags/cyrus-imapd-${finalAttrs.version}";
    hash = "sha256-dyybRqmrVX+ERGpToS5JjGC6S/B0t967dLCWfeUrLKA=";
  };
  cyrus-cli = fetchurl {
    url = "https://salsa.debian.org/debian/cyrus-imapd/-/raw/b77d8068d78d77c9cb7ec80465437f0e888f1607/debian/cyrus";
    hash = "sha256-PY4yooFIh20k5YsDFXnBjdWLYbSoJOvfmqamD/fxHOA=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    autoreconfHook
  ];
  buildInputs =
    [
      unixtools.xxd
      pcre2
      flex
      valgrind
      fig2dev
      perl
      cyrus_sasl.dev
      icu
      jansson
      libbsd
      libuuid
      openssl
      zlib
      bison
      libsrs2
    ]
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optionals (enableHttp || enableCalalarmd || enableJMAP) [
      brotli.dev
      libical.dev
      libxml2.dev
      nghttp2.dev
      shapelib
    ]
    ++ lib.optionals enableJMAP [
      libchardet
      wslay
    ]
    ++ lib.optionals enableXapian [
      rsync
      xapian
    ]
    ++ lib.optionals withMySQL [ libmysqlclient ]
    ++ lib.optionals withPgSQL [ postgresql ]
    ++ lib.optionals withSQLite [ sqlite ];

  enableParallelBuilding = true;

  patches = [
    # Shutdown and close sockets cleanly
    # PR at https://github.com/cyrusimap/cyrus-imapd/pull/3278
    (fetchpatch {
      url = "https://github.com/cyrusimap/cyrus-imapd/commit/bcfa4363e29e2a38e72da83e0fd99aa7d0e99837.patch";
      hash = "sha256-WpQ5ucXNEE4+qtnmnWAp4e9gRDstUzMbOnmnHMZ9J30=";
    })
  ];

  postPatch =
    let
      managesieveLibs = [
        zlib
        cyrus_sasl
      ] ++ lib.optional (!stdenv.isDarwin) libuuid;
      imapLibs = managesieveLibs ++ [ pcre2 ];
      mkLibsString = lib.strings.concatMapStringsSep " " (l: "-L${lib.getLib l}/lib");
    in
    ''
      patchShebangs cunit/*.pl
      patchShebangs imap/promdatagen
      patchShebangs tools/*

      echo ${finalAttrs.version} > VERSION

      substituteInPlace cunit/command.testc \
        --replace-fail /usr/bin/touch ${lib.getExe' coreutils "touch"} \
        --replace-fail /bin/echo ${lib.getExe' coreutils "echo"} \
        --replace-fail /usr/bin/tr ${lib.getExe' coreutils "tr"} \
        --replace-fail /bin/sh ${stdenv.shell}

      # Darwin doesn't have libuuid, try to build without it
      # fix for https://github.com/cyrusimap/cyrus-imapd/issues/3893
      substituteInPlace perl/imap/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString imapLibs} -lpcre2-posix $LIB_SASL'
      substituteInPlace perl/sieve/managesieve/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString managesieveLibs} $LIB_SASL'
    '';

  postInstall = ''
    install -Dm755 ${finalAttrs.cyrus-cli} $out/bin/cyrus
  '';

  postFixup = ''
    substituteInPlace $out/bin/cyrus \
      --replace-fail /usr/lib/cyrus/bin $out/bin
    wrapProgram $out/bin/cyradm --set PERL5LIB $(find $out/lib/perl5 -type d | tr "\\n" ":")
  '';

  configureFlags = [
    "--with-pidfile=/run/cyrus/master.pid"
    (lib.enableFeature enableAutoCreate "autocreate")
    (lib.enableFeature enableSrs "srs")
    (lib.enableFeature enableIdled "idled")
    (lib.enableFeature enableMurder "murder")
    (lib.enableFeature enableBackup "backup")
    (lib.enableFeature enableReplication "replication")
    (lib.enableFeature enableUnitTests "unit-tests")
    (lib.enableFeature (enableHttp || enableCalalarmd || enableJMAP) "http")
    (lib.enableFeature enableJMAP "jmap")
    (lib.enableFeature enableNNTP "nntp")
    (lib.enableFeature enableXapian "xapian")
    (lib.enableFeature enableCalalarmd "calalarmd")
    (lib.withFeature withZlib "zlib=${zlib}")
    (lib.withFeature withOpenssl "openssl")
    (lib.withFeature withLibcap "libcap=${libcap}")
    (lib.withFeature withMySQL "mysql")
    (lib.withFeature withPgSQL "pgsql")
    (lib.withFeature withSQLite "sqlite")
  ];

  checkInputs = [ cunit ];
  doCheck = true;

  passthru.tests = {
    version = testers.testVersion {
      package = cyrus-imapd;
      command = "${cyrus-imapd}/libexec/master -V";
    };
  };

  meta = {
    homepage = "https://www.cyrusimap.org";
    description = "Email, contacts and calendar server";
    license = with lib.licenses; [ bsdOriginal ];
    mainProgram = "cyrus";
    maintainers = with lib.maintainers; [
      moraxyc
      pingiun
    ];
    platforms = lib.platforms.unix;
  };
})
