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
  version = "0.1.7";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/libsvgtiny-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-LA3PlS8c2ILD6VQB75RZ8W27U8XT5FEjObL563add4E=";
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
