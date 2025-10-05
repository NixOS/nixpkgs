{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ruplacer";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "TankerHQ";
    repo = "ruplacer";
    rev = "v${version}";
    sha256 = "sha256-Zvbb9pQpxbJZi0qcDU6f2jEgavl9cA7gIYU7NRXZ9fc=";
  };

  cargoHash = "sha256-Ko6EBASK6olMyp0kDY4wgfpH+5j9vq0dJ74l8K6HPGY=";

  meta = {
    description = "Find and replace text in source files";
    mainProgram = "ruplacer";
    homepage = "https://github.com/TankerHQ/ruplacer";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
  };
}
