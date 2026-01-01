{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ncurses,
}:

rustPlatform.buildRustPackage rec {
  pname = "dijo";
  version = "0.2.7";
  buildInputs = [ ncurses ];
  src = fetchFromGitHub {
    owner = "oppiliappan";
    repo = "dijo";
    rev = "v${version}";
    sha256 = "sha256-g+A8BJxqoAvm9LTLrLnClVGtFJCQ2gT0mDGAov/6vXE=";
  };

  cargoHash = "sha256-Pny/RBtr65jKu2DdyIrluZWeZIgGb8Ev7mxvTMWPlyI=";

<<<<<<< HEAD
  meta = {
    description = "Scriptable, curses-based, digital habit tracker";
    homepage = "https://github.com/oppiliappan/dijo";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker";
    homepage = "https://github.com/oppiliappan/dijo";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "dijo";
  };
}
