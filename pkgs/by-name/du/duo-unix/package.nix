{
  lib,
  stdenv,
  fetchurl,
  pam,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duo-unix";
  version = "2.3.0";

  src = fetchurl {
    url = "https://dl.duosecurity.com/duo_unix-${finalAttrs.version}.tar.gz";
    hash = "sha256-40MCvtd1KdJJ6jFIuRVjpXeoCQ7ldZJRdLTNJzrcnqE=";
  };

  buildInputs = [
    pam
    openssl
    zlib
  ];
  configureFlags = [
    "--with-pam=$(out)/lib/security"
    "--prefix=$(out)"
    "--sysconfdir=$(out)/etc/duo"
    "--with-openssl=${openssl.dev}"
    "--enable-lib64=no"
  ];

  meta = {
    description = "Duo Security Unix login integration";
    homepage = "https://duosecurity.com";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
})
