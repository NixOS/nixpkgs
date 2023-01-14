{ lib, rustPlatform, fetchFromGitHub, stdenv, Security, webfs }:

rustPlatform.buildRustPackage rec {
  pname = "srvc";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "insilica";
    repo = "rs-srvc";
    rev = "v${version}";
    sha256 = "sha256-yeyAorVMHFl9wm57gmK6ZAI1w5daN2xl29Gqq0DsTtc=";
  };

  cargoHash = "sha256-/1TL0lWb4I9h6nGV7exx7U6ACrieN0EULTWg7Weexeg=";

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
