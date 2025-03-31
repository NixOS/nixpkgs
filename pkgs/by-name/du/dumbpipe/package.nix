{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "dumbpipe";
    rev = "v${version}";
    hash = "sha256-xQHVEJ+EgsrboXbPg7pGXXMjyedSLooqkTt/yYZACSo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uuY0nh4VHzyM7+cbgyycr5I3IjE0OeQ0eg12qVXe4BQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "dumbpipe";
  };
}
