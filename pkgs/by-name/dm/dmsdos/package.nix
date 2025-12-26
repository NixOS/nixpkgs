{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # cmake-4 support:
    #   https://github.com/sandsmark/dmsdos/pull/1
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/sandsmark/dmsdos/commit/94076ab27800e9cba41ab05e6bb2edbb421154d9.patch";
      hash = "sha256-olpnzPg/kbveUl0muwHKwI+DMGqXzxLrruFomf/SXjE=";
    })
  ];

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
