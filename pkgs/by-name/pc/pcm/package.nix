{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "pcm";
  version = "202509";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "pcm";
    rev = version;
    hash = "sha256-RIpyh4JN1/ePoSLQPyB3pgx6ifBcpJK+1d9YQcGZed4=";
  };

  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ roosemberth ];
=======
  meta = with lib; {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
}
