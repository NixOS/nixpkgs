{ fetchFromGitHub, automake, autoconf, which, pkg-config, libtool, lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "libcoap";
  version = "4.2.1";
  src = fetchFromGitHub {
    repo = "libcoap";
    owner = "obgm";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1jkvha52lic13f13hnppizkl80bb2rciayb5hxici0gj6spphgha";
  };
  nativeBuildInputs = [
    automake
    autoconf
    which
    libtool
    pkg-config
  ];
  preConfigure = "./autogen.sh";
  configureFlags = [
    "--disable-documentation"
    "--disable-shared"
  ];
  meta = with lib; {
    homepage = "https://github.com/obgm/libcoap";
    description = "A CoAP (RFC 7252) implementation in C";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = [ maintainers.kmein ];
  };
}
