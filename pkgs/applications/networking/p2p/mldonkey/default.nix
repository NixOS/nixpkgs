{ lib, stdenv, fetchurl, fetchpatch, ocamlPackages, zlib }:

stdenv.mkDerivation rec {
  pname = "mldonkey";
  version = "3.1.7-2";

  src = fetchurl {
    url = "https://ygrek.org/p/release/mldonkey/mldonkey-${version}.tar.bz2";
    sha256 = "b926e7aa3de4b4525af73c88f1724d576b4add56ef070f025941dd51cb24a794";
  };

  patches = [
    # Fixes C++17 compat
    (fetchpatch {
      url = "https://github.com/ygrek/mldonkey/pull/66/commits/20ff84c185396f3d759cf4ef46b9f0bd33a51060.patch";
      hash = "sha256-MCqx0jVfOaLkZhhv0b1cTdO6BK2/f6TxTWmx+NZjXME=";
    })
  ];

  preConfigure = ''
    substituteInPlace Makefile --replace '+camlp4' \
      '${ocamlPackages.camlp4}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/camlp4'
  '';

  buildInputs = (with ocamlPackages; [
    ocaml
    camlp4
    num
  ]) ++ [
    zlib
  ];

  meta = {
    broken = stdenv.isDarwin;
    description = "Client for many p2p networks, with multiple frontends";
    homepage = "http://mldonkey.sourceforge.net/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
