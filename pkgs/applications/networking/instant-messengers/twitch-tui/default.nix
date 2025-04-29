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
  version = "2.6.19";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-hA66YcxbQem9ymOu3tGA4biKUCoJ2jKnUSK+9+0P2Eg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DMUE3sTJEz2AxUctnjm0CkvOqMeAw5urLPZkkHvf9A8=";

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
