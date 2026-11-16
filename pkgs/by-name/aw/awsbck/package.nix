{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "awsbck";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1AnRXcLWMEOuTO4wpGL08nDPeW+oJpP1Su3zrP1gKMo=";
  };

  cargoHash = "sha256-Bmsg50TcpiTIkp/eaXJkkSrUIF0EVkoLg6ZTcLm1t4g=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  # tests run in CI on the source repo
  doCheck = false;

  meta = {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "awsbck";
  };
})
