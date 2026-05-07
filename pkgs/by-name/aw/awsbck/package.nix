{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "awsbck";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DZ2k0fwEyfeP24maTuxG2vmQaZuQ4LJo0KaKFTUDSYM=";
  };

  cargoHash = "sha256-wydSzfb8GAJYJPNtSyYBUHtN3+9jsGINSex2F3ILQKI=";

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
