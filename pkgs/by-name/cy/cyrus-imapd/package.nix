{
  # build tools
  stdenv,
  autoreconfHook,
  makeWrapper,
  pkg-config,

  # check hook
  versionCheckHook,

  # fetchers
  fetchFromGitHub,

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
  libpq,
  libsrs2,
  libuuid,
  libxml2,
  nghttp2,
  openssl,
  pcre2,
  perl,
  rsync,
  shapelib,
  sqlite,
  unixtools,
  valgrind,
  wslay,
  xapian,
  zlib,

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
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = "cyrusimap";
    repo = "cyrus-imapd";
    tag = "cyrus-imapd-${finalAttrs.version}";
    hash = "sha256-fwt8ierxM4bMp+ZfYINXUIcKNMnkTIWJTNWyv8GyX0c=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
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
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ]
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
  ++ lib.optionals withPgSQL [ libpq ]
  ++ lib.optionals withSQLite [ sqlite ];

  enableParallelBuilding = true;

  postPatch =
    let
      managesieveLibs = [
        zlib
        cyrus_sasl
        sqlite
      ]
      # Darwin doesn't have libuuid, try to build without it
      ++ lib.optional (!stdenv.hostPlatform.isDarwin) libuuid;
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

      # fix for https://github.com/cyrusimap/cyrus-imapd/issues/3893
      substituteInPlace perl/imap/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString imapLibs} -lpcre2-posix $LIB_SASL'
      substituteInPlace perl/sieve/managesieve/Makefile.PL.in \
        --replace-fail  '"$LIB_SASL' '"${mkLibsString managesieveLibs} $LIB_SASL'
    '';

  postFixup = ''
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

  versionCheckProgram = "${placeholder "out"}/libexec/master";
  versionCheckProgramArg = "-V";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://www.cyrusimap.org";
    description = "Email, contacts and calendar server";
    changelog = "https://www.cyrusimap.org/imap/download/release-notes/${lib.versions.majorMinor finalAttrs.version}/x/${finalAttrs.version}.html";
    license = with lib.licenses; [ bsdOriginal ];
    mainProgram = "cyradm";
    maintainers = with lib.maintainers; [
      moraxyc
      pingiun
    ];
    platforms = lib.platforms.unix;
  };
})
