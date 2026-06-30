{
  lib,
  stdenv,
  autoconf,
  automake,
  fetchurl,
  openssl,
  zlib,
  windows,

  # for passthru.tests
  aria2,
  curl,
  libgit2,
  mc,
  vlc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libssh2";
  version = "1.11.1-unstable-2026-06-30";

  src = fetchurl {
    url = "https://github.com/libssh2/libssh2/archive/6dc44da80e4ae2adfb188c1eefc5578c7bec0e67.tar.gz";
    hash = "sha256-whgtUJ6oMcHh32+FGKQ29KhxfPJ+6L3R/Tasq+xacZE=";
    name = finalAttrs.version;
  };

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  propagatedBuildInputs = [ openssl ]; # see Libs: in libssh2.pc
  buildInputs = [ zlib ] ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;
  nativeBuildInputs = [
    autoconf
    automake
  ];

  passthru.tests = {
    inherit
      aria2
      libgit2
      mc
      vlc
      ;
    curl = (curl.override { scpSupport = true; }).tests.withCheck;
  };

  meta = {
    description = "Client-side C library implementing the SSH2 protocol";
    homepage = "https://www.libssh2.org";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
