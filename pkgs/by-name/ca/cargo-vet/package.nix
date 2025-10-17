{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-vet";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cargo-vet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HSEhFCcdC79OA8MP73De+iLIjcr1XMHxfJ9a1Q3JJYI=";
  };

  cargoHash = "sha256-+X6DLxWPWMcGzJMVZAj3C5P5MyywIb4ml0Jsyo9/uAE=";

  # the test_project tests require internet access
  checkFlags = [ "--skip=test_project" ];

  meta = {
    description = "Tool to help projects ensure that third-party Rust dependencies have been audited by a trusted source";
    mainProgram = "cargo-vet";
    homepage = "https://mozilla.github.io/cargo-vet";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      figsoda
      jk
      matthiasbeyer
    ];
  };
})
