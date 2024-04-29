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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-d5qUleQrwWWTIEDj3VvJKpINHpc0rko18if4pv5GonU=";
  };

  cargoHash = "sha256-vlrllbcf5Y9DFwdekAHE5xtGlloKxTExXkp1LySEUK0=";

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
