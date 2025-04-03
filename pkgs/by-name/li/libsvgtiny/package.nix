{
  lib,
  stdenv,
  fetchurl,
  gperf,
  pkg-config,
  netsurf-buildsystem,
  libdom,
  libhubbub,
  libparserutils,
  libwapcaplet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsvgtiny";
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
    netsurf-buildsystem
    libdom
    libhubbub
    libparserutils
    libwapcaplet
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "NSSHARED=${netsurf-buildsystem}/share/netsurf-buildsystem"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libsvgtiny/";
    description = "NetSurf SVG decoder";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
