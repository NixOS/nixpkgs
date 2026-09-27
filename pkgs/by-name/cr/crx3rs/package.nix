{
  lib,
  fetchFromGitHub,
  nix-update-script,
  protobuf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "crx3rs";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "imishinist";
    repo = "crx3-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ajYuW9FfYzF7nbszXAS9KhhFGZcJoXGk34uaPKGeWLs=";
  };

  cargoHash = "sha256-e+sVyE2O1iYDOgN/vJfH2gwLE87T3E0TF7RdeCTLHhg=";

  env.PROTOC = lib.getExe' protobuf "protoc";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for working with Chrome extensions in the CRX3 format";
    homepage = "https://github.com/imishinist/crx3-rs";
    license = lib.licenses.mit;
    mainProgram = "crx3rs";
    maintainers = [ lib.maintainers.bricked ];
    platforms = lib.platforms.all;
  };
})
