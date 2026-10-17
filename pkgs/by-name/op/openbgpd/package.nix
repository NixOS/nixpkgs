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
  version = "9.3";

  src = fetchurl {
    url = "mirror://openbsd/OpenBGPD/openbgpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-tDwXLtw4D4cXHvHNE3tPzhy47sZQtUtk8YmhrlLSHHI=";
  };

  buildInputs = [
    libevent
  ];

  meta = {
    description = "Free implementation of the Border Gateway Protocol, Version 4. It allows ordinary machines to be used as routers exchanging routes with other systems speaking the BGP protocol";
    license = lib.licenses.isc;
    homepage = "http://www.openbgpd.org/";
    maintainers = with lib.maintainers; [ cve ];
    platforms = lib.platforms.linux;
  };
})
