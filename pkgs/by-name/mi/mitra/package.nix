{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage rec {
  pname = "mitra";
  version = "4.13.1";

  src = fetchFromCodeberg {
    owner = "silverpill";
    repo = "mitra";
    rev = "v${version}";
    hash = "sha256-cfE+4rbM5B9+ojevkoxc1ZY3r0TY5aRV8/qhZ3h4/0A=";
  };

  cargoHash = "sha256-45vFKMPc73XBHCJISdab59HIkY3a0va8BGQMWsrhaZg=";

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
