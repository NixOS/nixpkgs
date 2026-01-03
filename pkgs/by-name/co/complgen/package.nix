{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "complgen";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iwbU3DOzyPm3ZoyCRsgBZcSBSg48SsAMS/W4o5e3Gfs=";
  };

  cargoHash = "sha256-BGnTZxDv971s0h87RcOowoOpNdpwCx7FLcQNipPCTvc=";

  meta = {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    mainProgram = "complgen";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
