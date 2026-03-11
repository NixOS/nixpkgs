{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "awsbck";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DU806u9MsZHB+7LmjMgrkaHG+Hi4BJ9OGKkIdDGOhz8=";
  };

  cargoHash = "sha256-kgPpT79XSMGtnPkl4xrX3sddJQHcNSZlNmCcrxKqzuk=";

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
