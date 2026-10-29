{
  lib,
  stdenv,
  autoreconfHook,
  bison,
  fetchFromGitHub,
  flex,
  libmemcached,
  libpq,
  libxcrypt,
  openldap,
  openssl,
  pam,
  versionCheckHook,
  enableLdap ? true,
  enableMemcached ? true,
  enablePam ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgpool";
  version = "4.7.1";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "pgpool";
    repo = "pgpool2";
    tag = "V${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-npH4rhRToPVfKk7XyGGzdRSZMQ+APM8MBKHmd0rzlDw=";
  };

  patches = [
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
      lib.replaceString "." "-" finalAttrs.version
    }.html";
    license = lib.licenses.free;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    mainProgram = "pgpool";
  };
})
