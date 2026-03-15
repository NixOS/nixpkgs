{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "semtools";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "semtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dcB3oOoIBTCf9Tz1HCGiNic0TA6ybg1xetxM62utbVs=";
  };

  cargoHash = "sha256-chPXOkfrSwfJZAtiw3SxJQX1arR9M5+mYyEsCQRA/e8=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [ openssl ];

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic search and document parsing tools for the command line";
    homepage = "https://github.com/run-llama/semtools";
    changelog = "https://github.com/run-llama/semtools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
})
