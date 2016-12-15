{ stdenv, libsodium, callPackage, boost, zlib, openssl, gmp, procps, fetchFromGitHub }:

let atePairing = callPackage ./ate-pairing.nix { inherit xbyak; };
    mie        = callPackage ./mie.nix { };
    xbyak      = callPackage ./xbyak.nix {};
in
stdenv.mkDerivation rec{
  name = "snark";
  version = "2016-08-15-git";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "libsnark";
    rev = "2e6314a9f7efcd9af1c77669d7d9a229df86a777";
    sha256 = "0k4jhgc251d3ymga0sc1wiqhgklayr5d94n15jlb3n2lnqra07d5";
  };

  buildInputs = [ libsodium atePairing mie xbyak zlib openssl boost gmp ];

  makeFlags = [
    "PREFIX=$(out)"
    "CURVE=ALT_BN128"
    "NO_SUPERCOP=1"
    "STATIC=1"
  ];

  buildPhase = ''
    CXXFLAGS="-fPIC -DBINARY_OUTPUT -DNO_PT_COMPRESSION=1" \
    make lib \
      CURVE=ALT_BN128 \
      MULTICORE=1 \
      STATIC=1 \
      NO_PROCPS=1 \
      NO_GTEST=1 \
      FEATUREFLAGS=-DMONTGOMERY_OUTPUT \
  '';

  meta = with stdenv.lib; {
    description = "a C++ library for zkSNARK proofs";
    homepage = "https://github.com/zcash/libsnark";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
