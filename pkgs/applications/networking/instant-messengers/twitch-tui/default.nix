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
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sokOdM4Z2U/B23XEGONNHr2g9iuNz+Hm+on+7xMYD0E=";
  };

  cargoHash = "sha256-ngivv/2NDmY8c6eInzfdS4GjZQHWU3iJEFI3S+tf34M=";

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
