{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-readme";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "webern";
    repo = "cargo-readme";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-v158zqrbnrOVTHlOgLuq7fnTDUxrjeY0MskFbB3re90=";
  };

  cargoHash = "sha256-SJw/gKUhJ4lgMqj0eOx2LMhoSAcEAVjFMA2TzFoEnd0=";

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
      matthiasbeyer
      sshine
    ];
  };
})
