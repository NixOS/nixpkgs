{ lib, stdenv, fetchFromGitHub, cmake, libcifpp, libmcfp, zlib }:
let
  libcifpp' = libcifpp.overrideAttrs (oldAttrs:  rec {
    # dssp 4.3.1 requires specific version "5.1.0" of libcifpp
    version = "5.1.0";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo;
      rev = "v${version}";
      hash = "sha256-PUsi4T6huSqwaa6RnBP1Vj+0a1ePrvrHD0641Lkkc5s=";
    };
  });
in

stdenv.mkDerivation rec {
  pname = "dssp";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TE2fus3KaGd9jo7cOWmJSooHjxTbcxEldR1Mui2SGP0=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libcifpp' libmcfp zlib ];

  meta = with lib; {
    description = "Calculate the most likely secondary structure assignment given the 3D structure of a protein";
    homepage = "https://github.com/PDB-REDO/dssp";
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
