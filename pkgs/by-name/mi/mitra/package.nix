{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
  version = "4.4.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
    hash = "sha256-ZonEMbafZWfURW7WKUAVmDq7bvi7oXBpKVudbrTF6eE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-n96B51fVkJcBDwcbYHNP6ZWWdU8fu0a0Y72IVbNAAMQ=";

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
