{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "ducker";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    tag = "v${version}";
    sha256 = "sha256-aGqZlRIE4yjBzdHuONagQc7ePHcj1hOHszX6eKNxy+A=";
  };

  cargoHash = "sha256-gkckXyKPiJTbIVAfUyOrJPQcvU/Cu9OcRsf4NG7Ve/M=";

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
