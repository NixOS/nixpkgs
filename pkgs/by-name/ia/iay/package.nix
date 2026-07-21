{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iay";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "aaqaishtyaq";
    repo = "iay";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oNUK2ROcocKoIlAuNZcJczDYtSchzpB1qaYbSYsjN50=";
  };

  cargoHash = "sha256-QO9gzJKSBMs5s1fCfpBuyHDK9uE1B148bMjp8RjH4nY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

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
