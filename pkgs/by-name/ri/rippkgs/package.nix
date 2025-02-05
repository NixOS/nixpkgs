{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "rippkgs";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "replit";
    repo = "rippkgs";
    tag = "v${version}";
    hash = "sha256-CQGmTXzAj3wA7UTwdeL7gujbT4duS8QE5yZzGKwvzog=";
  };

  cargoHash = "sha256-zXsZ0GpcGOfgilkuRX7RyEseWkQcBA91yliCI4mkVFA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  meta = {
    description = "CLI for indexing and searching packages in Nix expressions";
    homepage = "https://github.com/replit/rippkgs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cdmistman ];
    mainProgram = "rippkgs";
  };
}
