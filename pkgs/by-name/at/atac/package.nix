{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "atac";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-ChX2LMRbqoKzl+QKkeervrCHr3plAQ21RzC4RqEucCA=";
  };

  cargoHash = "sha256-nYkXL3SIjG3REE+w2vIlB04FWs7e0d4iu0hRjAPz7aU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      oniguruma
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "A simple API client (postman like) in your terminal";
    homepage = "https://github.com/Julien-cpsn/ATAC";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
    mainProgram = "atac";
  };
}
