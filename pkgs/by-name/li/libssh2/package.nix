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

    (fetchurl {
      name = "CVE-2025-15661.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/CVE-2025-15661.patch";
      hash = "sha256-Rz6i/881CbObUDcZbcPlgVPaKizSp6ZRTdmJNJ9HLHE=";
    })

    (fetchurl {
      name = "CVE-2026-55199.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/CVE-2026-55199.patch";
      hash = "sha256-AFZa5kohha62aE0if5ckmAdJ0TZNcjfP32yDznoEhNo=";
    })

    (fetchurl {
      name = "CVE-2026-55200.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/CVE-2026-55200.patch";
      hash = "sha256-wCAglr8BsBWIhnh3SiFeyKzZmIp8rC5MVfFgoEzp/hE=";
    })

    # necessary for the fix for CVE-2026-15661
    (fetchurl {
      name = "libssh-unconst-backport.patch";
      url = "https://salsa.debian.org/debian/libssh2/-/raw/1d4906e6ebe85a9da2931ba33677ead96a61f07f/debian/patches/libssh-unconst-backport.patch";
      hash = "sha256-jc01Fb70GbaD9+RYeSjRaLFBtKLiMPTMuXas21aC0Ag=";
    })
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
