{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:
rustPlatform.buildRustPackage rec {
  pname = "goldentests";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "jfecher";
    repo = "golden-tests";
    rev = "2d15f0bad8c808f09d7a632e17a1653ae94d5c04";
    hash = "sha256-JLejQaYttwdA95rUv3+mRYu+oIMv9ov0gD2HT0vJ3gQ=";
  };

  cargoHash = "sha256-DxqtCvFnP/+13x5ZHq0np3AasbtyYPMkdvn9+amDDTo=";

  buildFeatures = [ "binary" ];

  nativeBuildInputs = [
    python3 # used in tests
  ];

  meta = {
    description = "A golden file testing CLI";
    mainProgram = "goldentests";
    homepage = "https://github.com/jfecher/golden-tests";
    changelog = "https://github.com/jfecher/golden-tests/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rpqt ];
    platforms = lib.platforms.unix;
  };
}
