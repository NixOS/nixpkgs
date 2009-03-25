{stdenv, fetchurl, boost, zlib, botan, libidn,
  lua, pcre, sqlite}:

let 
  version = "0.43";
in stdenv.mkDerivation {
  name = "monotone-${version}";
  src = fetchurl {
    url = "http://monotone.ca/downloads/${version}/monotone-${version}.tar.gz";
    sha256 = "1vfvvk4flv6n7x1nrizjpwpsfhf3dv3b60h7cs4ysgvzb76s41mz";
  };
  buildInputs = [boost zlib botan libidn lua pcre sqlite];
  preConfigure = ''
    export sqlite_LIBS=-lsqlite3
    export NIX_LDFLAGS="$NIX_LDFLAGS -ldl"
  '';
}
