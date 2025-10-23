{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dmsdos";
  version = "unstable-2021-02-06";

  src = fetchFromGitHub {
    owner = "sandsmark";
    repo = "dmsdos";
    rev = "c9044d509969d3d1467b781c08233e15c1da7a13";
    hash = "sha256-oGVkDf1gFaSMRpvHq4GNLN8htBm/sYawZeVwiqQxjL8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Linux utilities to handle dos/win95 doublespace/drivespace/stacker";
    homepage = "https://github.com/sandsmark/dmsdos.git";
    changelog = "https://github.com/sandsmark/dmsdos/blob/${finalAttrs.src.rev}/NEWS";
    license = with lib.licenses; [
      lgpl2
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "dmsdos";
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
  };
})
