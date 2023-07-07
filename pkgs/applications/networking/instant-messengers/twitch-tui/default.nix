{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-tui";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-giD26vFR+KRcPwNlZD23Km9AYS5iYUlBfhIiMpScIiE=";
  };

  cargoHash = "sha256-wUw11toTHtm/opa8TBIcbPK/pjOZZCUieeIXCdn4oto=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Twitch chat in the terminal";
    homepage = "https://github.com/Xithrius/twitch-tui";
    changelog = "https://github.com/Xithrius/twitch-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.taha ];
  };
}
