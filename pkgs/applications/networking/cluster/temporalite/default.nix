{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "temporalite";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "temporalite";
    rev = "v${version}";
    sha256 = "sha256-rLEkWg5LNVb7i/2IARKGuP9ugaVJA9pwYbKLm0QLmOc=";
  };

  vendorSha256 = "sha256-vjuwh/HRRYfB6J49rfJxif12nYPnbBodWF9hTiGygS8=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  subPackages = [ "./cmd/temporalite" ];

  doCheck = false;

  meta = with lib; {
    description = "An experimental distribution of Temporal that runs as a single process";
    homepage = "https://temporal.io";
    changelog = "https://github.com/temporalio/temporalite/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sagikazarmark ];
  };
}
