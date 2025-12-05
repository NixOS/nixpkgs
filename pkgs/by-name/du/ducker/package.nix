{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ducker";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${version}";
    sha256 = "sha256-I2lAJY+lB7COwo1Sk70/CUl6xfAGGy7qEl4U69Tx4wI";
  };

  cargoHash = "sha256-lvIKIkPIFz3RKyoEFCCH9u5yBSC8Q1QocfGfQvqBUYI=";

  meta = {
    description = "Terminal app for managing docker containers, inspired by K9s";
    homepage = "https://github.com/robertpsoane/ducker";
    changelog = "https://github.com/robertpsoane/ducker/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ducker";
    platforms = with lib.platforms; unix ++ windows;
    maintainers = with lib.maintainers; [ anas ];
  };
}
