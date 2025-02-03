{ lib
, stdenv
, fetchurl
, gperf
, pkg-config
, buildsystem
, libdom
, libhubbub
, libparserutils
, libwapcaplet
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-libsvgtiny";
  version = "0.1.8";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libsvgtiny-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-w1cifwLoP7KnaxK5ARkaCCIp2x8Ac2Lo8xx1RRDCoBw=";
  };

  nativeBuildInputs = [
    gperf
    pkg-config
  ];

  buildInputs = [
    buildsystem
    libdom
    libhubbub
    libparserutils
    libwapcaplet
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libsvgtiny/";
    description = "NetSurf SVG decoder";
    license = lib.licenses.mit;
    inherit (buildsystem.meta) maintainers platforms;
  };
})
