{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "csa";
  version = "1.26-unstable-2024-03-22";

  src = fetchFromGitHub {
    owner = "sakov";
    repo = "csa-c";
    rev = "7b48134613d1d3b337af6d5762df9999a703fb1a";
    hash = "sha256-G/VhXpdvXBT9I6pwiQXVqCoXhc29wJQpGyLeM3kgv7I=";
  };

  sourceRoot = "${finalAttrs.src.name}/csa";

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "C code for cubic spline approximation of 2D scattered data";
    homepage = "https://github.com/sakov/csa-c/";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mkez ];
    mainProgram = "csabathy";
  };
})
