{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-IFdhfBri1k5u7NfC1HTSegKCtRDK2fz+WkjwHOtp1qk=";
  };

  cargoHash = "sha256-9RKsnGjbP0iQsC2iCq6LTleILHvX0powQu15oopE2XY=";

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
