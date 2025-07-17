{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "sizelint";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "sizelint";
    tag = "v${version}";
    hash = "sha256-bFOe8zrWzfIPzOn6NAHD5y943/v8cwCMzC2pTPEUi2Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-h5NJXxiGe3TIFt2aa08XAxPB2rtuBva/6GEhajin4OE=";

  meta = {
    description = "Lint your file tree based on file sizes";
    homepage = "https://github.com/a-kenji/sizelint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "sizelint";
  };
}
