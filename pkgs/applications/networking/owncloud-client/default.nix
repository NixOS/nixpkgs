{ stdenv, fetchurl, cmake, qt4, pkgconfig, qtkeychain, sqlite }:

stdenv.mkDerivation rec {
  name = "owncloud-client-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "https://download.owncloud.com/desktop/stable/owncloudclient-${version}.tar.xz";
    sha256 = "10ah4zmnv4hfi50k59qwk990h1a4g95d3yvxqqrv4x1dv8p2sscf";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ qt4 qtkeychain sqlite];

  cmakeFlags = [
  "-UCMAKE_INSTALL_LIBDIR"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Synchronise your ownCloud with your computer using this desktop client";
    homepage = https://owncloud.org;
    maintainers = [ maintainers.qknight ];
    platforms = platforms.unix;
  };
}
