{ lib, stdenv, fetchFromGitHub, cmake, libcifpp, libmcfp, zlib }:
let
  libcifpp' = libcifpp.overrideAttrs (oldAttrs:  rec {
    # dssp 4.2.2.1 requires specific version "5.0.8" of libcifpp
    version = "5.0.8";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo;
      rev = "v${version}";
      sha256 = "sha256-KJGcopGhCWSl+ElG3BPJjBf/kvYJowOHxto6Ci1IMco=";
    };
  });
in

stdenv.mkDerivation rec {
  pname = "dssp";
  version = "4.2.2.1";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vmGvC5d8LTo+pcY9sxwj0d6JvH8Lyk+QSOZo5raBci4=";
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
