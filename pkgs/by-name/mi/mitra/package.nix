{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
  version = "3.13.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
    hash = "sha256-jAh3sWOHbqo5EpH+Ap/AOha2AKk6iwMvyUme6Ct96qI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GDhdMShO+W05ny/hgXKcwDzcO9Stk3NM4U95ArImRYU=";

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
