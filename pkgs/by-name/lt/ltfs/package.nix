{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  fuse,
  icu78,
  net-snmp,
  libuuid,
  libtool,
  libxml2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "v2.4.8.3-10521";
  pname = "ltfs";

  src = fetchFromGitHub {
    rev = finalAttrs.version;
    fetchSubmodules = true;
    owner = "LinearTapeFileSystem";
    repo = "ltfs";
    hash = "sha256-O1BwzUsGtFPqpSZJqmYOVQAdYW7FBr2G61ZBimbrXMo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    autoconf
    automake
    fuse
    icu78.dev
    net-snmp
    libtool
    libuuid
    libxml2
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-declaration-after-statement";
  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    description = "Reference implementation of the open-source tape filesystem standard ltfs";
    homepage = "https://github.com/LinearTapeFileSystem/ltfs";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ implr ];
  };
})
