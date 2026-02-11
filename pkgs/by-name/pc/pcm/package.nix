{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcm";
  version = "202509";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "pcm";
    rev = finalAttrs.version;
    hash = "sha256-RIpyh4JN1/ePoSLQPyB3pgx6ifBcpJK+1d9YQcGZed4=";
  };

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

  meta = {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
})
