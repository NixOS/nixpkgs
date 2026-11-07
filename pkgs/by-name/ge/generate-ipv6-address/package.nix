{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "generate-ipv6-address";
  version = "0.1";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/generate-ipv6-address-0.1.tar.gz";
    hash = "sha256-4TVtJF1fiR+jm3lqii3u/aqJ8IEw3JejeHOMpe2aIPo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Utility to generate IPv6 addresses according to RFC 4193";
    mainProgram = "generate-ipv6-address";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dvn0 ];
  };
})
