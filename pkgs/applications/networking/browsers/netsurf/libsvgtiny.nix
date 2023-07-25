{ lib, stdenv, fetchurl, pkg-config, gperf
, buildsystem
, libdom
, libhubbub
, libparserutils
, libwapcaplet
}:

stdenv.mkDerivation rec {
  pname = "netsurf-${libname}";
  libname = "libsvgtiny";
  version = "0.1.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/${libname}-${version}-src.tar.gz";
    sha256 = "sha256-LA3PlS8c2ILD6VQB75RZ8W27U8XT5FEjObL563add4E=";
  };

  nativeBuildInputs = [ pkg-config gperf ];
  buildInputs = [
    libdom
    libhubbub
    libparserutils
    libwapcaplet
    buildsystem ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = with lib; {
    homepage = "https://www.netsurf-browser.org/projects/${libname}/";
    description = "NetSurf SVG decoder";
    license = licenses.mit;
    maintainers = [ maintainers.samueldr maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
