{
  lib,
  stdenv,
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
  version = "1.11.1";

  src = fetchurl {
    url = "https://www.libssh2.org/download/libssh2-${finalAttrs.version}.tar.gz";
    hash = "sha256-2ex2y+NNuY7sNTn+LImdJrDIN8s+tGalaw8QnKv2WPc=";
  };

  patches = [
    # https://github.com/libssh2/libssh2/commit/256d04b60d80bf1190e96b0ad1e91b2174d744b1
    ./CVE-2026-7598.patch
  ];

  # this could be accomplished by updateAutotoolsGnuConfigScriptsHook, but that causes infinite recursion
  # necessary for FreeBSD code path in configure
  postPatch = ''
    substituteInPlace ./config.guess --replace-fail /usr/bin/uname uname
  '';

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  propagatedBuildInputs = [ openssl ]; # see Libs: in libssh2.pc
  buildInputs = [ zlib ] ++ lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;

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
