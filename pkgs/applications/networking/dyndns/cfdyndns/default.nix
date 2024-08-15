{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cfdyndns";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "nrdxp";
    repo = "cfdyndns";
    rev = "v${version}";
    hash = "sha256-OV1YRcZDzYy1FP1Bqp9m+Jxgu6Vc0aWpbAffNcdIW/4=";
  };

  cargoLock.lockFile = ./Cargo.lock;
  cargoLock.outputHashes."cloudflare-0.12.0" = "sha256-8/C5mHN7g/k3q9BzFC9TIKMlgmBsmvC4xWVEoz1Sz9c=";
  cargoLock.outputHashes."public-ip-0.2.2" = "sha256-DDdh90EAo3Ppsym4AntczFuiAQo4/QQ9TEPJjMB1XzY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "CloudFlare Dynamic DNS Client";
    mainProgram = "cfdyndns";
    homepage = "https://github.com/nrdxp/cfdyndns";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ colemickens nrdxp ];
    platforms = with platforms; linux;
  };
}
