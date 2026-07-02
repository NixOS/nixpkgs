{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pcm";
  version = "202604";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "pcm";
    rev = finalAttrs.version;
    hash = "sha256-TWE/5rsCCfoKDAy9i9YDRiUXVnqAX7I08Oq6QgCbzaY=";
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
