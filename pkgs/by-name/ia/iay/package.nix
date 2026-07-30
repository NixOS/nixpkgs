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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "aaqaishtyaq";
    repo = "iay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H0h3ChS+B8+Pnet8rNQIkpr4k/t7P2hYrS06dademUU=";
  };

  cargoHash = "sha256-66bhmIk/YCweL9GquPpObkkl2Sn45IlU2HqnKn43294=";

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
