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
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-q7Z7a/Mfi6djUGK0xvhD0WznxQlDyejZtaq9rSlNz8g=";
  };

  cargoHash = "sha256-utnwDqQe0PScRXUD/mC6/uSX8cjBHLbRsO0GcVntPKk=";

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
