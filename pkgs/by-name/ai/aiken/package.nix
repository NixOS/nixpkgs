{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
  version = "1.1.19";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    tag = "v${version}";
    hash = "sha256-S3KIOlOz21ItWI+RoeHPYROIlMbKAoNi7hXwHHjHaJs=";
  };

  cargoHash = "sha256-RrcP23p3KVIGKiW1crDDn5eoowjX3nTPUWBYtT9qdz0=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aciceri ];
    mainProgram = "aiken";
  };
}
