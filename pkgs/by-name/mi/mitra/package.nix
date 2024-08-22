{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
  version = "3.9.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
    hash = "sha256-reBG9h3jI4ONxYIwM2QdXlTC8ohmSrPm18sLOeI/2wY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WoJzFhxBDHuUNGaNsqieev93hg0Eo604tAM0HZJv9tA=";

  # MEMO: mitra v3.9.0 tests failed with cargo option, "--offline"
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
