{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "pcm";
  version = "202502";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "pcm";
    rev = version;
    hash = "sha256-U6V3LX+JlVL9MRFBP3xpYwPQ6Y7pnJ4F/7dpKG3Eyuw=";
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
}
