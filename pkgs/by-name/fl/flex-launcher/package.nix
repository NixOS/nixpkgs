{
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  libX11,
  cmake,
  validatePkgConfig,
  inih,
  lib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flex-launcher";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = "flex-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-touQMOKvp+D1vIYvyz/nU7aU9g6VXpDN3BPgoK/iYfw=";
  };

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    libX11
    inih
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Customizable HTPC application launcher";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ MasterEvarior ];
    homepage = "https://complexlogic.github.io/flex-launcher/";
    changelog = "https://github.com/complexlogic/flex-launcher/releases/tag/v${finalAttrs.version}";
    mainProgram = "flex-launcher";
  };
})
