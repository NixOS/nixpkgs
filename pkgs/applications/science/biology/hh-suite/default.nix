{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  xxd,
  enableMpi ? false,
  mpi,
  openmp,
}:
stdenv.mkDerivation rec {
  pname = "hh-suite";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "soedinglab";
    repo = "hh-suite";
    rev = "v${version}";
    hash = "sha256-kjNqJddioCZoh/cZL3YNplweIGopWIGzCYQOnKDqZmw=";
  };

  patches = [
    # Should be removable as soon as this upstream PR is merged: https://github.com/soedinglab/hh-suite/pull/357
    (fetchpatch {
      name = "fix-gcc13-build-issues.patch";
      url = "https://github.com/soedinglab/hh-suite/commit/cec47cba5dcd580e668b1ee507c9282fbdc8e7d7.patch";
      hash = "sha256-Msdmj9l8voPYXK0SSwUA6mEbFLBhTjjE/Kjp0VL4Kf4=";
    })
  ];

  nativeBuildInputs = [
    cmake
    xxd
  ];
  cmakeFlags =
    lib.optional stdenv.hostPlatform.isx86 "-DHAVE_SSE2=1"
    ++ lib.optional stdenv.hostPlatform.isAarch "-DHAVE_ARM8=1"
    ++ lib.optional stdenv.hostPlatform.avx2Support "-DHAVE_AVX2=1"
    ++ lib.optional stdenv.hostPlatform.sse4_1Support "-DHAVE_SSE4_1=1";

  buildInputs = lib.optional stdenv.cc.isClang openmp ++ lib.optional enableMpi mpi;

  meta = with lib; {
    description = "Remote protein homology detection suite";
    homepage = "https://github.com/soedinglab/hh-suite";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
