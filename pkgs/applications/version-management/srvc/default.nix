{ lib, rustPlatform, fetchFromGitHub, stdenv, Security, webfs }:

rustPlatform.buildRustPackage rec {
  pname = "srvc";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "insilica";
    repo = "rs-srvc";
    rev = "v${version}";
    sha256 = "sha256-XslMwA1DhztK9DPNCucUpzjCQXz6PN8ml8JBvKtJeqg=";
  };

  cargoSha256 = "sha256-KxwBF5t8lcaH8ZD4SorIBiq7p6r9LGHfEOyNXtB9HJw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  checkInputs = [ webfs ];

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
