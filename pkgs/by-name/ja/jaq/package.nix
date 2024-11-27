{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    hash = "sha256-ehCZOvBcYa7BQusFJhWiWU/htnETwzw6awqGKMY3DR4=";
  };

  cargoHash = "sha256-FjM3WsPEd5iiPNzrH8MdQvLF1YAeVit0nCXo8ziSftg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda siraben ];
    mainProgram = "jaq";
  };
}
