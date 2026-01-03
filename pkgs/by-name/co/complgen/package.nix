{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-iwbU3DOzyPm3ZoyCRsgBZcSBSg48SsAMS/W4o5e3Gfs=";
  };

  cargoHash = "sha256-BGnTZxDv971s0h87RcOowoOpNdpwCx7FLcQNipPCTvc=";

  meta = {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    mainProgram = "complgen";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
