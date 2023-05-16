<<<<<<< HEAD
{ lib
, stdenv
, cmake
, fetchFromGitHub
, libcifpp
, libmcfp
, zlib
}:
let
  libcifpp' = libcifpp.overrideAttrs (oldAttrs: {
    # dssp 4.3.1 requires specific version "5.1.0" of libcifpp
    version = "5.1.0";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo rev;
      hash = "sha256-PUsi4T6huSqwaa6RnBP1Vj+0a1ePrvrHD0641Lkkc5s=";
=======
{ lib, stdenv, fetchFromGitHub, cmake, libcifpp, libmcfp, zlib }:
let
  libcifpp' = libcifpp.overrideAttrs (oldAttrs:  rec {
    # dssp 4.2.2.1 requires specific version "5.0.8" of libcifpp
    version = "5.0.8";
    src = fetchFromGitHub {
      inherit (oldAttrs.src) owner repo;
      rev = "v${version}";
      sha256 = "sha256-KJGcopGhCWSl+ElG3BPJjBf/kvYJowOHxto6Ci1IMco=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  });
in

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "dssp";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "PDB-REDO";
    repo = "dssp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Gic/rE/G24P5g4Uhf2lcvVa6i/4KGQzCpK4KlpjXcS0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libcifpp'
    libmcfp
    zlib
  ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Calculate the most likely secondary structure assignment given the 3D structure of a protein";
    homepage = "https://github.com/PDB-REDO/dssp";
<<<<<<< HEAD
    changelog = "https://github.com/PDB-REDO/libcifpp/releases/tag/${finalAttrs.src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
