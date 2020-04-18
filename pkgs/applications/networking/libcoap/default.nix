{ fetchFromGitHub, automake, autoconf, which, pkgconfig, libtool, stdenv }:
stdenv.mkDerivation rec {
  pname = "libcoap";
  version = "4.2.0";
  src = fetchFromGitHub {
    repo = "libcoap";
    owner = "obgm";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0mmvkq72i4rda6b7g93qrwg2nwh2rvkq4xw70yppj51hsdrnpfl7";
  };
  nativeBuildInputs = [
    automake
    autoconf
    which
    libtool
    pkgconfig
  ];
  preConfigure = "./autogen.sh";
  configureFlags = [
    "--disable-documentation"
    "--disable-shared"
  ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/obgm/libcoap";
    description = "A CoAP (RFC 7252) implementation in C";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ maintainers.kmein ];
  };
}
