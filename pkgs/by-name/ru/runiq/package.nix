{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "runiq";
  version = "2.0.0-unstable-2024-08-19";

  src = fetchFromGitHub {
    owner = "whitfin";
    repo = "runiq";
    rev = "a642926f6ec09d4faeebebb563d4aed89e0d36fb";
    hash = "sha256-DWP0kbTjXlyUI/+bHgom9/XJ2XW/BJEU4xvIisPVug0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Efficient way to filter duplicate lines from input, à la uniq";
    mainProgram = "runiq";
    homepage = "https://github.com/whitfin/runiq";
    license = licenses.mit;
    maintainers = [ ];
  };
}
