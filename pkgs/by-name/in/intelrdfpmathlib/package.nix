{
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "IntelRDFPMathLib";
  version = "20U3";

  src = fetchurl {
    url = "http://www.netlib.org/misc/intel/IntelRDFPMathLib${finalAttrs.version}.tar.gz";
    hash = "sha256-E/aSSy7XHfmxN6ffmHBqDcw7Q8KDoOMvi26tykMFE2o=";
  };
  sourceRoot = "LIBRARY";

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/intelrdfpmath/-/raw/042b4056499b0e60e67bd9a19fb641f898e72d9f/debian/patches/debian-arches.patch";
      stripLen = 1;
      hash = "sha256-wCwAyXUmWY4XzzI0OeqKILdq9CI0mn5v2/gu8b57pR4=";
    })
  ];

  installPhase = ''
    install -D -t $out/lib *.a
    install -D -t $out/include src/bid_conf.h
    install -D -t $out/include src/bid_functions.h
  '';

  meta = {
    description = "Intel Decimal Floating-Point Math Library";
  };
})
