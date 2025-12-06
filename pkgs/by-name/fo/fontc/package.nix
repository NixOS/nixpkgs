{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fontc";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "fontc";
    tag = "fontc-v${finalAttrs.version}";
    hash = "sha256-g+Hu4ucj0bT8f3UPiuFTyySwku10CCMt/sjJHMaLVwc=";
  };
  buildAndTestSubdir = "fontc";

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tidy-sys-0.8.2" = "sha256-Okt+mqakdwm0OlD4UXBtQIbO+Wmlk6jTMWi9Q5Y1M2o=";
    };
  };

  meta = {
    description = "Wherein we pursue oxidizing fontmake";
    homepage = "https://github.com/googlefonts/fontc";
    changelog = "https://github.com/googlefonts/fontc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ shiphan ];
    mainProgram = "fontc";
  };
})
