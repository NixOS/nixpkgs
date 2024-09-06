{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "sig";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "sig";
    rev = "v${version}";
    hash = "sha256-nt/KV4ohFNZTJTwbNoSxb5v9zQwp+7ypvfMthL1yMus=";
  };

  cargoHash = "sha256-gZZ2aOsqVqGN3gCBZnBXzlFicMssNIEyRT688OuNMJc=";

  meta = {
    description = "Interactive grep (for streaming)";
    homepage = "https://github.com/ynqa/sig";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qaidvoid ];
    mainProgram = "sig";
  };
}
