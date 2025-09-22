{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "socket_wrapper";
  version = "1.5.1";

  src = fetchurl {
    url = "mirror://samba/cwrap/socket_wrapper-${version}.tar.gz";
    sha256 = "sha256-miEZA+G3BeORbMUJ0MbV8PjftutYf0SOEdjiAJtHdaU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "Library passing all socket communications through unix sockets";
    homepage = "https://git.samba.org/?p=socket_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
