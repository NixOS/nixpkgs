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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+dKS9lp5M8vh0V4VGyWAozozdsyCPpCZR4CQK5s51Ds=";
  };

  cargoHash = "sha256-CzrOsLUTfZ2uEIj/AHFmdfZniwlQ6fIkL2pbBHF8YkU=";

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
