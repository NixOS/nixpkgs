{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-vet";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cargo-vet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pib5HI2rdMFZOo8+QvCZTxBAcgjZh4MoBAmc0AsBfFg=";
  };

  cargoHash = "sha256-epJWvKJ6Ks3eBfL+Ve9XydrJN+ses8J3OO2jld2PBag=";

  # the test_project tests require internet access
  checkFlags = [ "--skip=test_project" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to help projects ensure that third-party Rust dependencies have been audited by a trusted source";
    changelog = "https://github.com/mozilla/cargo-vet/releases/tag/v${finalAttrs.version}";
    mainProgram = "cargo-vet";
    homepage = "https://mozilla.github.io/cargo-vet";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      jk
      matthiasbeyer
      ilkecan
    ];
  };
})
