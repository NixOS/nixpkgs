{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "genemichaels";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "andrewbaxter";
    repo = "genemichaels";
    rev = "genemichaels-v${version}";
    hash = "sha256-qPyIC9AbRQI+inBft7Dd5R5v+tXtJcZdiV4lBIBwpyM=";
  };

  cargoHash = "sha256-yPxgYf8N3Dqns/uKhdM++jpzG7zTPhCVVq+7WA9G/SM=";

  cargoBuildFlags = [ "--package ${pname}" ];

  meta = {
    description = "Even formats macros";
    homepage = "https://github.com/andrewbaxter/genemichaels";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ djacu ];
    mainProgram = "genemichaels";
  };
}
