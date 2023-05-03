{ lib
, stdenv
, fetchFromGitHub
, cmake
, xxd
, enableMpi ? false
, mpi
, openmp
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

  nativeBuildInputs = [ cmake xxd ];
  cmakeFlags = lib.optional stdenv.hostPlatform.isx86 "-DHAVE_SSE2=1"
    ++ lib.optional stdenv.hostPlatform.isAarch "-DHAVE_ARM8=1"
    ++ lib.optional stdenv.hostPlatform.avx2Support "-DHAVE_AVX2=1"
    ++ lib.optional stdenv.hostPlatform.sse4_1Support "-DHAVE_SSE4_1=1";

  buildInputs = lib.optional stdenv.cc.isClang openmp
    ++ lib.optional enableMpi mpi;

  meta = with lib; {
    description = "Remote protein homology detection suite";
    homepage = "https://github.com/soedinglab/hh-suite";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
}
