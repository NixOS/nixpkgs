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

stdenv.mkDerivation rec {
  pname = "libssh2";
  version = "1.11.1";

  src = fetchurl {
    url = "https://www.libssh2.org/download/libssh2-${version}.tar.gz";
    hash = "sha256-2ex2y+NNuY7sNTn+LImdJrDIN8s+tGalaw8QnKv2WPc=";
  };

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

  meta = with lib; {
    description = "Client-side C library implementing the SSH2 protocol";
    homepage = "https://www.libssh2.org";
    platforms = platforms.all;
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
