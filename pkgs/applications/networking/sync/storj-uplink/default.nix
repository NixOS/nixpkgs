{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "storj-uplink";
  version = "1.113.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    rev = "v${version}";
    hash = "sha256-nf2fNnkY6Z0T5dfSRUmqYpstV5yP+dJiZqB/AF3NR94=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-NnFCs64xUoFFHFQs/3YtdJkUurd3TxNieZJ96VqnJaU=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with maintainers; [ felipeqq2 ];
  };
}
