{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nixosTests,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "rathole";
  version = "0.5.0-unstable-2024-06-06";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = "rathole";
    rev = "be14d124a22e298d12d92e56ef4fec0e51517998";
    hash = "sha256-C0/G4JOZ4pTAvcKZhRHsGvlLlwAyWBQ0rMScLvaLSuA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-IgPDe8kuWzJ6nF2DceUbN7fw0eGkoYhu1IGMdlSMFos=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ CoreServices ]);

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit (nixosTests) rathole;
  };

  meta = {
    description = "Reverse proxy for NAT traversal";
    homepage = "https://github.com/rapiz1/rathole";
    license = lib.licenses.asl20;
    mainProgram = "rathole";
    maintainers = with lib.maintainers; [
      dit7ya
      xokdvium
    ];
  };
}
