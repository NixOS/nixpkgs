{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-C5QaOxZ9DQuda+slf8uqPQYVgDtS5Lhm3AFn8K2G/T4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Pb4tnP8BiVTfUR1qM1dUXj9aCmdK23YYxQ4KQQc4z54=";

  # tests run in CI on the source repo
  doCheck = false;

  meta = with lib; {
    description = "Backup a folder to AWS S3, once or periodically";
    homepage = "https://github.com/beeb/awsbck";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ beeb ];
    mainProgram = "awsbck";
  };
}
