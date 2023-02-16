{ lib, rustPlatform, fetchFromGitHub, stdenv, Security, git }:

rustPlatform.buildRustPackage rec {
  pname = "srvc";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "insilica";
    repo = "rs-srvc";
    rev = "v${version}";
    sha256 = "sha256-gid3zPN9fdUqqNnRKvhEfzO4rJqZ3lWwmlP6SWEUyAY=";
  };

  cargoHash = "sha256-UWKD2qXyxGepFK90QkyhyR7PJrK1wUiwQZjApoz9tqU=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
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
