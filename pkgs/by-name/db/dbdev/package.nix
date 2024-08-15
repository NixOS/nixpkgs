{
  lib,
  darwin,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "dbdev";
  version = "2024-12-13";
  sourceRoot = "${src.name}/cli";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "dbdev";
    rev = "684b07312b2cf64d599ec114d66a6e3af351ba66";
    sha256 = "S0Y3Yag+dit3Ef0dbe5YFFB1IACXYzoJFmGBSAEG3OA=";
  };

  cargoHash = "sha256-2Nzd2ZtsWamIRX+Lg829z4xmJCJGIaJsXs4PYw0h/m4=";

  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Database Package Registry for Postgres";
    mainProgram = "dbdev";
    homepage = "https://github.com/supabase/dbdev";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ david-r-cox ];
  };
}
