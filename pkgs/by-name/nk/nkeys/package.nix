{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5HmtCzY2EmlnBqg36JcjaaM2ivrM5f719bkWqpxekVI=";
  };

  vendorHash = "sha256-AJrfHMNjuGO8LbuP4cAVClKWHkqkG+nPzQw+B+nRpxM=";

  meta = with lib; {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nk";
  };
}
