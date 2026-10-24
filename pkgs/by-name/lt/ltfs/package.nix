{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  autoreconfHook,
  fuse,
  icu78,
  net-snmp,
  libuuid,
  libtool,
  libxml2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.4.8.4-10522";
  pname = "ltfs";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    owner = "LinearTapeFileSystem";
    repo = "ltfs";
    hash = "sha256-E3qMdZL7UF/phUjayxLGBLpDG9rDXzG5cFECY+tlNlM=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    icu78
    libtool
    net-snmp
    pkg-config
  ];

  buildInputs = [
    fuse
    icu78
    libuuid
    libxml2
  ];

  configureFlags = [
    "CFLAGS=-Wno-declaration-after-statement"
    "--enable-fast"
  ];

  meta = {
    description = "Reference implementation of the open-source tape filesystem standard ltfs";
    homepage = "https://github.com/LinearTapeFileSystem/ltfs";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux ++ darwin ++ freebsd ++ netbsd;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ implr ];
  };
})
