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
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${version}";
    hash = "sha256-nYPqj3Wa5itw83s08qsEu30v/2NwkLwGE0LlNY9Msok=";
  };

  cargoHash = "sha256-Beh5out4Ess+FP+Dg601ZqyXotEfujqNX16Vupp5WRc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      oniguruma
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
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
