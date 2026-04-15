{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openexr,
  libtiff,
  aces-container,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctl";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "ampas";
    repo = "CTL";
    rev = "ctl-${finalAttrs.version}";
    hash = "sha256-X6W6IXZUMBTZJTzpAk7FmoEhSPELTmhYv68dZmqUJ2g=";
  };

  nativeBuildInputs = [
    cmake
    openexr
    libtiff
    aces-container
  ];

  meta = {
    description = "Programming language for digital color management";
    homepage = "https://github.com/ampas/CTL";
    changelog = "https://github.com/ampas/CTL/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.ampas;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "ctl";
    platforms = lib.platforms.all;
  };
})
