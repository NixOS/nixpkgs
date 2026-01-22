{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

  patches = [
    # fixes libdom build on gcc 14 due to calloc-transposed-args warning
    # remove on next release
    (fetchpatch {
      name = "fix-calloc-transposed-args.patch";
      url = "https://source.netsurf-browser.org/libsvgtiny.git/patch/?id=9d14633496ae504557c95d124b97a71147635f04";
      hash = "sha256-IRWWjyFXd+lWci/bKR9uPDKbP3ttK6zNB6Cy5bv4huc=";
    })
  ];

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

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.netsurf-browser.org/projects/libsvgtiny/";
    description = "NetSurf SVG decoder";
    license = lib.licenses.mit;
    inherit (netsurf-buildsystem.meta) maintainers platforms;
  };
})
