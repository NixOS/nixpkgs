{
  lib,
  stdenv,
  autoreconfHook,
  bison,
  fetchFromGitHub,
  flex,
  libmemcached,
  libpq,
  libtool,
  libxcrypt,
  openldap,
  openssl,
  pam,
  versionCheckHook,
  enableLdap ? true,
  enableMemcached ? true,
  enablePam ? true,
}:

stdenv.mkDerivation rec {
  pname = "pgpool";
  version = "4.7.0";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "pgpool";
    repo = "pgpool2";
    tag = "V${builtins.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-2uPXKrEyvuBY+FkQAr4Pk0zsJSQPJn0SKrMUu8ZvCGk=";
  };

  patches = [
    ./fix-parallel-build.patch
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # Build checks for strlcpy being available in the system, but doesn't
    # actually exclude its own copy from being built
    ./darwin-strlcpy.patch
    # Fix strchrnul not available on Darwin
    ./darwin-strchrnul.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    libtool
  ];

  buildInputs = [
    libpq
    libxcrypt
    openssl
  ]
  ++ lib.optional enableLdap openldap
  ++ lib.optional enableMemcached libmemcached
  ++ lib.optional enablePam pam;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.cc.isClang) [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.withFeature true "openssl")
    (lib.withFeature enableLdap "ldap")
    (lib.withFeature enablePam "pam")
    (lib.withFeatureAs enableMemcached "memcached" (lib.getDev libmemcached))
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  enableParallelBuilding = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Middleware that works between PostgreSQL servers and PostgreSQL clients";
    homepage = "https://pgpool.net/";
    changelog = "https://www.pgpool.net/docs/latest/en/html/release-${
      builtins.replaceStrings [ "." ] [ "-" ] version
    }.html";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "pgpool";
  };
}
