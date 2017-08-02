{ stdenv, libsodium, callPackage, boost, zlib, openssl, gmp, procps, fetchFromGitHub }:

let atePairing = callPackage ./ate-pairing.nix { inherit xbyak; };
    mie        = callPackage ./mie.nix { };
    xbyak      = callPackage ./xbyak.nix {};
in
stdenv.mkDerivation rec{
  name = "libsnark-unstable-${version}";
  version = "2017-02-09";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "libsnark";
    rev = "9ada3f84ab484c57b2247c2f41091fd6a0916573";
    sha256 = "0vhslcb9rwqab9szavyn856z4h9w1syiamfcixqmj0s908zzlaaq";
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
    homepage = https://github.com/zcash/libsnark;
    maintainers = with maintainers; [ rht ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
