{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {

  pname = "bkt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "dimo414";
    repo = "bkt";
    tag = version;
    sha256 = "sha256-XQK7oZfutqCvFoGzMH5G5zoGvqB8YaXSdrwjS/SVTNU=";
  };

  cargoHash = "sha256-4CY2A6mPTfGhqUh+nNg6eaTIVwA9ZtgH5jHQDGHnK4c=";

  meta = {
    description = "Subprocess caching utility";
    homepage = "https://github.com/dimo414/bkt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "bkt";
  };
}
