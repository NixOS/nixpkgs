{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ducker";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "robertpsoane";
    repo = "ducker";
    rev = "v${version}";
    hash = "sha256-rCzn+uv60LUB8H8reth6Mus3VBgBNPqLRgCWz+nXDDw=";
  };

  cargoHash = "sha256-qRnduB1ZH6sSumRhtlKIm8heflvbutS5Xy2ODhFrQRQ=";

  # There is no tests
  doCheck = false;

  meta = {
    description = "A terminal app for managing docker containers, inspired by K9s";
    homepage = "https://github.com/robertpsoane/ducker";
    changelog = "https://github.com/robertpsoane/ducker/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "ducker";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
