{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ducker";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${version}";
    sha256 = "sha256-mC6MWVg6T8w9YQvu1UDpiDplsoKb3UN+LFgzveBgyew=";
  };

  cargoHash = "sha256-DOH0fykhONoFtKZ4Mlgu8GLEQ6o5T1V9box1qG/pEQA=";

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
