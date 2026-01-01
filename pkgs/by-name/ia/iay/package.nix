{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "iay";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "aaqaishtyaq";
    repo = "iay";
    rev = "v${version}";
    sha256 = "sha256-oNUK2ROcocKoIlAuNZcJczDYtSchzpB1qaYbSYsjN50=";
  };

  cargoHash = "sha256-QO9gzJKSBMs5s1fCfpBuyHDK9uE1B148bMjp8RjH4nY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  NIX_LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin [
    "-framework"
    "AppKit"
  ];

<<<<<<< HEAD
  meta = {
    description = "Minimalistic, blazing-fast, and extendable prompt for bash and zsh";
    homepage = "https://github.com/aaqaishtyaq/iay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Minimalistic, blazing-fast, and extendable prompt for bash and zsh";
    homepage = "https://github.com/aaqaishtyaq/iay";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      aaqaishtyaq
    ];
    mainProgram = "iay";
  };
}
