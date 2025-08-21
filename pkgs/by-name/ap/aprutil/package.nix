{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  apr,
  expat,
  gnused,
  sslSupport ? true,
  openssl,
  bdbSupport ? true,
  db,
  ldapSupport ? !stdenv.hostPlatform.isCygwin,
  openldap,
  libiconv,
  libxcrypt,
  cyrus_sasl,
  autoreconfHook,
}:

assert sslSupport -> openssl != null;
assert bdbSupport -> db != null;
assert ldapSupport -> openldap != null;

stdenv.mkDerivation rec {
  pname = "apr-util";
  version = "1.6.3";

  src = fetchurl {
    url = "mirror://apache/apr/${pname}-${version}.tar.bz2";
    sha256 = "sha256-pBB243EHRjJsOUUEKZStmk/KwM4Cd92P6gdv7DyXcrU=";
  };

  patches = [
    ./fix-libxcrypt-build.patch
    # Fix incorrect Berkeley DB detection with newer versions of clang due to implicit `int` on main errors.
    ./clang-bdb.patch
  ]
  ++ lib.optional stdenv.hostPlatform.isFreeBSD ./include-static-dependencies.patch;

  NIX_CFLAGS_LINK = [ "-lcrypt" ];

  outputs = [
    "out"
    "dev"
  ];
  outputBin = "dev";

  nativeBuildInputs = [
    makeWrapper
    autoreconfHook
  ];

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-expat=${expat.dev}"
  ]
  ++ lib.optional (!stdenv.hostPlatform.isCygwin) "--with-crypto"
  ++ lib.optional sslSupport "--with-openssl=${openssl.dev}"
  ++ lib.optional bdbSupport "--with-berkeley-db=${db.dev}"
  ++ lib.optional ldapSupport "--with-ldap=ldap"
  ++ lib.optionals stdenv.hostPlatform.isCygwin [
    "--without-pgsql"
    "--without-sqlite2"
    "--without-sqlite3"
    "--without-freetds"
    "--without-berkeley-db"
    "--without-crypto"
  ];

  postConfigure = ''
    echo '#define APR_HAVE_CRYPT_H 1' >> confdefs.h
  ''
  +
    # For some reason, db version 6.9 is selected when cross-compiling.
    # It's unclear as to why, it requires someone with more autotools / configure knowledge to go deeper into that.
    # Always replacing the link flag with a generic link flag seems to help though, so let's do that for now.
    lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace Makefile \
        --replace "-ldb-6.9" "-ldb"
      substituteInPlace apu-1-config \
        --replace "-ldb-6.9" "-ldb"
    '';

  propagatedBuildInputs = [
    apr
    expat
    libiconv
    libxcrypt
  ]
  ++ lib.optional sslSupport openssl
  ++ lib.optional bdbSupport db
  ++ lib.optional ldapSupport openldap
  ++ lib.optional stdenv.hostPlatform.isFreeBSD cyrus_sasl;

  postInstall = ''
    for f in $out/lib/*.la $out/lib/apr-util-1/*.la $dev/bin/apu-1-config; do
      substituteInPlace $f \
        --replace "${expat.dev}/lib" "${expat.out}/lib" \
        --replace "${db.dev}/lib" "${db.out}/lib" \
        --replace "${openssl.dev}/lib" "${lib.getLib openssl}/lib"
    done

    # Give apr1 access to sed for runtime invocations.
    wrapProgram $dev/bin/apu-1-config --prefix PATH : "${gnused}/bin"
  '';

  enableParallelBuilding = true;

  passthru = {
    inherit sslSupport bdbSupport ldapSupport;
  };

  meta = with lib; {
    homepage = "https://apr.apache.org/";
    description = "Companion library to APR, the Apache Portable Runtime";
    mainProgram = "apu-1-config";
    maintainers = [ ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
