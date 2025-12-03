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
stdenv.mkDerivation rec {
  pname = "libcoap";
  version = "4.3.5a";
  src = fetchFromGitHub {
    repo = "libcoap";
    owner = "obgm";
    rev = "v${version}";
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
  meta = with lib; {
    homepage = "https://github.com/obgm/libcoap";
    description = "CoAP (RFC 7252) implementation in C";
    platforms = platforms.unix;
    license = licenses.bsd2;
    maintainers = [ maintainers.kmein ];
  };
}
