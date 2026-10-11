{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "csa";
  version = "1.26-unstable-2024-03-22";

  src = fetchFromGitHub {
    owner = "sakov";
    repo = "csa-c";
    rev = "7b48134613d1d3b337af6d5762df9999a703fb1a";
    hash = "sha256-G/VhXpdvXBT9I6pwiQXVqCoXhc29wJQpGyLeM3kgv7I=";
  };

  sourceRoot = "${finalAttrs.src.name}/csa";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "C code for cubic spline approximation of 2D scattered data";
    homepage = "https://github.com/sakov/csa-c/";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mkez ];
    mainProgram = "csabathy";
  };
})
