{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
  version = "4.8.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
    hash = "sha256-hBbqlL5E0iSMtnGFCdVnKkCUcNwmBPkOnyEY+aAlw0o=";
  };

  cargoHash = "sha256-tk+WJaYBUteFfNfRuD45KNK0QaFMFUiDbaaqmwtPORQ=";

  # require running database
  doCheck = false;

  RUSTFLAGS = [
    # MEMO: mitra use ammonia crate with unstable rustc flag
    "--cfg=ammonia_unstable"
  ];

  buildFeatures = [
    "production"
  ];

  meta = {
    description = "Federated micro-blogging platform";
    homepage = "https://codeberg.org/silverpill/mitra";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "mitra";
  };
}
