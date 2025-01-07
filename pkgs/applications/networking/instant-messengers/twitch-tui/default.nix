{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  CoreServices,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-tui";
  version = "2.6.17";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QwFCabksDG+G7nfQPtxshd4n71Dj/uKOGRRutnZxECM=";
  };

  cargoHash = "sha256-EEZZaTIDrVcygfXg7/cLOnrVeDfpP88Q16RQ+Bl7eUI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
