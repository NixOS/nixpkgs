{
  fetchFromGitHub,
  automake,
  autoconf,
  which,
  pkg-config,
  libtool,
  lib,
  stdenv,
  gnutls,
  asciidoc,
  doxygen,
  withTLS ? true,
  withDocs ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libcoap";
  version = "4.3.5a";
  src = fetchFromGitHub {
    repo = "libcoap";
    owner = "obgm";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mLVGIG2JkWMlnZOlLxFTZVGM0nF6q2PKJoEo0s4Vq54=";
  };
  nativeBuildInputs = [
    automake
    autoconf
    which
    libtool
    pkg-config
  ]
  ++ lib.optional withTLS gnutls
  ++ lib.optionals withDocs [
    doxygen
    asciidoc
  ];
  preConfigure = "./autogen.sh";
  configureFlags = [
    "--disable-shared"
  ]
  ++ lib.optional (!withDocs) "--disable-documentation"
  ++ lib.optional withTLS "--enable-dtls";
  meta = {
    homepage = "https://github.com/obgm/libcoap";
    description = "CoAP (RFC 7252) implementation in C";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.kmein ];
  };
})
