{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-readme";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "webern";
    repo = "cargo-readme";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Urp5OvM6LzLb8SY49u2Dc57NFJtyxpMkvCbb6hTUDMs=";
  };

  cargoHash = "sha256-CmYJ8acmcaWregM0zroaTFaPFV6cnS2KWf5Y4LXMcyk=";

  # disable doc tests
  cargoTestFlags = [
    "--bins"
    "--lib"
  ];

  meta = {
    description = "Generate README.md from docstrings";
    mainProgram = "cargo-readme";
    homepage = "https://github.com/livioribeiro/cargo-readme";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      baloo
      matthiasbeyer
    ];
  };
})
