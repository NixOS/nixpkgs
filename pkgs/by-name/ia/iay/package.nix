{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iay";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "aaqaishtyaq";
    repo = "iay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eb5J+9AFKU/rQEcwHrVNIaQXAsOqfmI8JPKfNMsTGrg=";
  };

  cargoHash = "sha256-Ma/gv2x5hm+pa5AW+FnRiD7ueIz76dCOFhAvX1P/nlM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [ gitMinimal ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "AppKit"
    ];
  };

  meta = {
    description = "Minimalistic, blazing-fast, and extendable prompt for bash and zsh";
    homepage = "https://github.com/aaqaishtyaq/iay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aaqaishtyaq
    ];
    mainProgram = "iay";
  };
})
