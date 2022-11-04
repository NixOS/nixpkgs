{ lib, fetchFromGitHub, rustPlatform, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "srvc";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "insilica";
    repo = "rs-srvc";
    rev = "v${version}";
    sha256 = "sha256-XGZ6Jr/RVDOLDa0sANZIsKtNjY3pEBlOtei+xNGPBBY=";
  };

  cargoSha256 = "sha256-sjMg5XMnAQZjp6z9prtRq+0pyNQ1oTm0/KWOZPxDW4w=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Sysrev version control";
    homepage = "https://github.com/insilica/rs-srvc";
    license = licenses.asl20;
    maintainers = with maintainers; [ john-shaffer ];
  };
}
