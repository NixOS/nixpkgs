{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.1.21";
  src = fetchFromGitHub {
    owner = "andrewbaxter";
    repo = pname;
    rev = "158bb8eb705b073d84562554c1a6a63eedd44c6b";
    hash = "sha256-rAJYukxptasexZzwWgtGlUbHhyyI6OJvSzVxGLBO9vM=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-hziKQVnNz7rve55ofJ3hBwDBxiylEV5ZQolDvxgUW0E=";

  meta = {
    description = "Even formats macros";
    mainProgram = "genemichaels";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
