{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mupen64plus,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mupen64plus-rsp-parallel";
  version = "0-unstable-2025-02-10";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "parallel-rsp";
    rev = "738c95cdb3acdc6340b3047e27d6c256e8bc81a6";
    hash = "sha256-5Fxs1f9bl2uIahX2ToGILZe2Hu7iewLSND6ntuySd7A=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    mupen64plus
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "ParaLLEl-RSP with mupen64plus-highscore patches";
    homepage = "https://github.com/highscore-emu/parallel-rsp";
    license = lib.licenses.mit;
    inherit (libhighscore.meta) maintainers platforms;
  };
})
