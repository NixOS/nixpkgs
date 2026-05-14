{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "russ";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ckampfe";
    repo = "russ";
    rev = "b21aa80ebc9dc2668463386f9eb270b1782d5842";
    hash = "sha256-/76CvSBYim831OZzLhsj2Hm+0hoY/FLtKQqt19E5YOI=";
  };

  cargoHash = "sha256-G2s/IggPXfi7FXOoM5s9I9PEphYHjEdg9W1LCAxIk1M=";

  # tests are network based :(
  doCheck = false;

  meta = {
    changelog = "https://github.com/ckampfe/russ/blob/master/CHANGELOG.md";
    description = "TUI RSS reader with vim-like controls and a local-first, offline-first focus";
    homepage = "https://github.com/ckampfe/russ";
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [ blusk ];
    mainProgram = "russ";
  };
}
