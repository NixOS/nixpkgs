{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "buildsystem";
  version = "1.9";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}.tar.gz";
    sha256 = "sha256-k4QeMUpoggmiC4dF8GU5PzqQ8Bvmj0Xpa8jS9KKqmio=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf browser shared build system";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
