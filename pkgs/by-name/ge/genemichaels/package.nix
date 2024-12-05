{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.1.21";
  src = fetchFromGitHub {
    owner = "andrewbaxter";
    repo = pname;
    rev = "158bb8eb705b073d84562554c1a6a63eedd44c6b";
    hash = "sha256-rAJYukxptasexZzwWgtGlUbHhyyI6OJvSzVxGLBO9vM=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes."markdown-1.0.0-alpha.5" = "sha256-pjIKzXvRKoMfFVIyIXdm+29vvUzCHiJ0rrZgr4K+Ih8=";
  };
  meta = {
    description = "Even formats macros";
    mainProgram = "genemichaels";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
