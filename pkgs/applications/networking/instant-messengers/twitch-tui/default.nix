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
  version = "2.6.18";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-uo9QEwSRIJKjWza8dEQXDCMQ/ydKBk/BX2TaVhX+k1M=";
  };

  cargoHash = "sha256-QYT5Aqwl2m/+SZlw55Ep3dIfmESSNowN30JJ52mY/Lk=";

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
