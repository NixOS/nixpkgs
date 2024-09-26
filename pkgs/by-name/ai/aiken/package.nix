{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-n373MgPjJzP+yRSQLA07RijFBjbRItK/nX8k7SJ6ITE=";
  };

  cargoHash = "sha256-gQ7DfYyVF6Gk8N+spBd97BWxTwydq+lDbnCsVPPzWLU=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreServices
        SystemConfiguration
      ]
    );

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "aiken";
  };
}
