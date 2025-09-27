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

  meta = with lib; {
    description = "Scriptable, curses-based, digital habit tracker";
    homepage = "https://github.com/oppiliappan/dijo";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "dijo";
  };
}
