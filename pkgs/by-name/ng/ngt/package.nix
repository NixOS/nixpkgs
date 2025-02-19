{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  enableAVX ? stdenv.hostPlatform.avxSupport,
}:

stdenv.mkDerivation rec {
  pname = "NGT";
  version = "1.12.3-alpha";

  src = fetchFromGitHub {
    owner = "yahoojapan";
    repo = "NGT";
    rev = "29c88ff6cd5824d3196986d1f50b834565b6c9dd";
    sha256 = "sha256-nu0MJNpaenOB4+evoSVLKmPIuZXVj1Rm9x53+TfhezY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.openmp ];

  NIX_ENFORCE_NO_NATIVE = !enableAVX;
  __AVX2__ = if enableAVX then 1 else 0;

  meta = with lib; {
    homepage = "https://github.com/yahoojapan/NGT";
    description = "Nearest Neighbor Search with Neighborhood Graph and Tree for High-dimensional Data";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ tomberek ];
  };
}
