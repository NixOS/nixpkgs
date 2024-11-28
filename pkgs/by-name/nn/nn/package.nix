{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "nn";
  version = "2.0.8-unstable-2024-04-08";

  src = fetchFromGitHub {
    owner = "sakov";
    repo = "nn-c";
    rev = "f8e880b6ae39ff4bb4d617f61db5f92311bd04b6";
    hash = "sha256-SzkLxR5ZkIlCoMlN18+uc1/xYWhHhXMdd2PpA1jvnFI=";
  };

  sourceRoot = "${finalAttrs.src.name}/nn";

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "C code for Natural Neighbours interpolation of 2D scattered data";
    homepage = "https://github.com/sakov/nn-c/";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mkez ];
  };
})
