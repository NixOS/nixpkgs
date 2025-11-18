{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "awsbck";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "awsbck";
    rev = "v${version}";
    hash = "sha256-WWYUMamMDtnvOR7vjoKd1Kn8vJBAAa9Jj8MFPRGQfEQ=";
  };

  cargoHash = "sha256-eo7NBGDPhu+v07dUUw/k1O62gxbeXh1PdPogTjg6l8I=";

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
