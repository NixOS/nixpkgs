{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "srvc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "insilica";
    repo = "rs-srvc";
    rev = "v${version}";
    sha256 = "sha256-PBs86cvEacvCt/2JnURL4qKvXGXRZHWaGYrPUSsnt0I=";
  };

  cargoSha256 = "sha256-5CUbfI67gsINdHcxN8KbIN10Mu90rAU53DbmQ5QotWg=";

  meta = with lib; {
    description = "Sysrev version control";
    homepage = "https://github.com/insilica/rs-srvc";
    license = licenses.asl20;
    maintainers = with maintainers; [ john-shaffer ];
  };
}
