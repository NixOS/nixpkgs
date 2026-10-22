{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "awsbck";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wRk+zMVPMEikoyK4gp3rMKqUzHGBPSzflZa/9QTnRxQ=";
  };

  cargoHash = "sha256-njhyCY4UxTnStNKJ2m2TZgsF2EcVQdb4hyosZwRq8co=";

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
