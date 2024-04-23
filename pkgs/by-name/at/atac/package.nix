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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-yR+w6zrX7XHrK6XGWM7J74XPxGEmy8Gf6guOH/Du6rc=";
  };

  cargoHash = "sha256-Ez8d1tb0Xi91e3+U1/LDmj5u/oORQzelEQPFAC96yEI=";

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
