{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ducker";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${version}";
    sha256 = "sha256-Fy9GoV5M26wQVCuGrJuX6kjPcql9VKz4xXMttbJ9/KI=";
  };

  cargoHash = "sha256-GWF5jyTAH7bWOqi3WetEv3gIJ0PmMQoV6+7p+TwgQY8=";

  meta = {
    description = "Terminal app for managing docker containers, inspired by K9s";
    homepage = "https://github.com/robertpsoane/ducker";
    changelog = "https://github.com/robertpsoane/ducker/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ducker";
    platforms = with lib.platforms; unix ++ windows;
  };
}
