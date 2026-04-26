{
  lib,
  clangStdenv,
  fetchurl,
  libevent,
}:
# Use clang instead of gcc because that issues way less warnings.
# Besides, OpenBSD devs generally prefer clang over gcc, so it is more likely
# that the entire compilation is more tested using clang from an upstream POV.
clangStdenv.mkDerivation (finalAttrs: {
  pname = "openbgpd";
  version = "9.0";

  src = fetchurl {
    url = "https://cdn.openbsd.org/pub/OpenBSD/OpenBGPD/openbgpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-4JfE81Gibx3lM5IS2eENTPWrxLgQXk8cSI7wZakD9hU=";
  };

  buildInputs = [
    libevent
  ];

  meta = {
    description = "Free implementation of the Border Gateway Protocol, Version 4. It allows ordinary machines to be used as routers exchanging routes with other systems speaking the BGP protocol";
    license = lib.licenses.isc;
    homepage = "http://www.openbgpd.org/";
    maintainers = with lib.maintainers; [ cvengler ];
    platforms = lib.platforms.linux;
  };
})
