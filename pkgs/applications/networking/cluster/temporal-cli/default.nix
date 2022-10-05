{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    sha256 = "sha256-GZTCxHs2/HeQIYRkhGzNYYyCd/vcGRey2lsFU7fV4gM=";
  };

  vendorSha256 = "sha256-9bgovXVj+qddfDSI4DTaNYH4H8Uc4DZqeVYG5TWXTNw=";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "tctl";
  };
}
