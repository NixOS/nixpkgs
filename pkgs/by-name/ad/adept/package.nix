{
  lib,
  autoconf,
  automake,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adept";
  version = "2.1.1";

  src = fetchurl {
    url = "https://www.met.reading.ac.uk/clouds/adept/adept-${finalAttrs.version}.tar.gz";
    hash = "sha256-DO8zToLfRSbTdhvdgxmmPnWCyWsvHMiDkXKQGLSCXEc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  doCheck = true;

  meta = {
    description = "Combined array and automatic differentiation library in C++";
    homepage = "https://www.met.reading.ac.uk/clouds/adept/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      athas
    ];
  };
})
