{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin, git }:

rustPlatform.buildRustPackage rec {
  pname = "srvc";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "insilica";
    repo = "rs-srvc";
    rev = "v${version}";
    hash = "sha256-ymDQJjD/7uY0nC0eJhSkT/X/oBSwVt6nAOOb81IKOQ4=";
  };

  cargoHash = "sha256-OMw/n8STqjT1e3iWwJU4R1UzhhctF6gLkAddy5EWapc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [ git ];

  # remove timeouts in tests to make them less flaky
  TEST_SRVC_DISABLE_TIMEOUT = 1;

  meta = with lib; {
    description = "Sysrev version control";
    homepage = "https://github.com/insilica/rs-srvc";
    changelog = "https://github.com/insilica/rs-srvc/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ john-shaffer ];
    mainProgram = "sr";
  };
}
