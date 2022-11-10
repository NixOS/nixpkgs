{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "srvc";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "insilica";
    repo = "rs-srvc";
    rev = "v${version}";
    sha256 = "sha256-2eEuKAMxxTwjDInpYcOlFJha5DTe0IrxT5rI6ymN0hc=";
  };

  cargoSha256 = "sha256-nJM7/w4awbCZQysUOSTO6bfsBXO3agJRdp1RyRZhtUY=";

  # remove timeouts in tests to make them less flaky
  patches = [ ./tests-no-timeout.patch ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Sysrev version control";
    homepage = "https://github.com/insilica/rs-srvc";
    license = licenses.asl20;
    maintainers = with maintainers; [ john-shaffer ];
    mainProgram = "sr";
  };
}
