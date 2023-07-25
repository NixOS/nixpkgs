{ lib, stdenv, fetchurl, pkg-config
, buildsystem
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libnsbmp";
  version = "0.1.6";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-ecSTZfhg7UUb/EEJ7d7I3j6bfOWjvgaVlr0qoZJ5Mk8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/";
    description = "BMP Decoder for netsurf browser";
    license = licenses.mit;
    maintainers = [ maintainers.vrthra maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
