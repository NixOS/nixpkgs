{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-7ykDkCA6c5MzaMWT+ZjNBhPOZO8UNYIP5sNwoFx1XT8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-L7iWM5T/FRK+0KQROILg4Mns1+cwPPGKfe0H00FJrSo=";

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
