{ lib, stdenv, fetchurl
, autoreconfHook, pkg-config, txt2man, which
, openssl, nss, p11-kit, libical, ldns, unbound, apr, aprutil
}:

stdenv.mkDerivation rec {
  pname = "redwax-tool";
  version = "0.9.7";

  src = fetchurl {
    url = "https://archive.redwax.eu/dist/rt/redwax-tool-${version}/redwax-tool-${version}.tar.gz";
    hash = "sha256-GYxThKyvgeyQ1ksfRrqvDUC+8j/0WgskMgz2/4qN1R4=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config txt2man which ];
  buildInputs = [ openssl nss p11-kit libical ldns libunbound apr aprutil ];

  meta = with lib; {
    homepage = "https://redwax.eu/rt/";
    description = "Universal certificate conversion tool";
    mainProgram = "redwax-tool";
    longDescription = ''
      Read certificates and keys from your chosen sources, filter the
      certificates and keys you're interested in, write those
      certificates and keys to the destinations of your choice.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ astro ];
  };
}
