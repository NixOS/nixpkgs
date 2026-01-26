{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ducker";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${version}";
    sha256 = "sha256-e9L0K6dP0DjMpN0TDLkqu4wmff8cEfHmB7PRP+mQiR8=";
  };

  cargoHash = "sha256-K76VDSqXSNxMGFBrtv5oV49IwvMu7rglmiYaWXR3fBE=";

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
