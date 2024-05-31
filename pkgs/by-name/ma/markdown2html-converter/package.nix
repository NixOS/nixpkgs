{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "markdown2html-converter";
  version = "1.1.12";

  src = fetchFromGitHub {
    owner = "magiclen";
    repo = "markdown2html-converter";
    rev = "refs/tags/v${version}";
    hash = "sha256-C35TCmcskhK3sHbkUp3kEaTA4P7Ls5Rn6ahUbzy7KXY=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    changelog = "https://github.com/magiclen/markdown2html-converter/releases/tag/v${version}";
    description = "Tool for converting a Markdown file to a single HTML file with built-in CSS and JS";
    homepage = "https://github.com/magiclen/markdown2html-converter";
    license = lib.licenses.mit;
    mainProgram = "markdown2html-converter";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
