{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, CoreServices
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-tui";
  version = "2.6.12";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mEpeuopMzZhWOAikEP7Er8xcgNkGbCTkJJYrQr7GrBQ=";
  };

  cargoHash = "sha256-U9L4SrYTAUcQ9/2f8tD7jxByVQS9P6OXpra6QvbhNNg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
    Security
    SystemConfiguration
  ];

  meta = with lib; {
    description = "Twitch chat in the terminal";
    homepage = "https://github.com/Xithrius/twitch-tui";
    changelog = "https://github.com/Xithrius/twitch-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.taha ];
    mainProgram = "twt";
  };
}
