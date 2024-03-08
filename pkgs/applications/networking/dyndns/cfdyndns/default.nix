{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cfdyndns";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "nrdxp";
    repo = "cfdyndns";
    rev = "v${version}";
    hash = "sha256-iwKMTWLK7pgz8AEmPVBO1bTWrXTokQJ+Z1U4CiiRdho=";
  };

  cargoLock.lockFile = ./Cargo.lock;
  cargoLock.outputHashes."cloudflare-0.10.1" = "sha256-AJW4AQ34EDhxf7zMhFY2rqq5n4IaSVWJAYi+7jXEUVo=";
  cargoLock.outputHashes."public-ip-0.2.2" = "sha256-DDdh90EAo3Ppsym4AntczFuiAQo4/QQ9TEPJjMB1XzY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "CloudFlare Dynamic DNS Client";
    homepage = "https://github.com/nrdxp/cfdyndns";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ colemickens nrdxp ];
    platforms = with platforms; linux;
  };
}
