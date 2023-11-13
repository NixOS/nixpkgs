{ lib
, stdenv
, darwin
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-commander-rs";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bp4bP77nWi0XLhI4/wsry6fEW2BR90Y+XqV/WCinwJo=";
  };

  cargoHash = "sha256-HPkpCnlSZ9sY40gc4dLOdcBhATvJVeqk7GJ0+XqjHVk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "matrix-commander-rs";
  };
}
