{ lib, buildGoModule, fetchFromGitHub, testers, plow }:

buildGoModule rec {
  pname = "plow";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "six-ddc";
    repo = "plow";
    rev = "refs/tags/v${version}";
    hash = "sha256-TynFq7e4MtZlA5SmGMybhmCVw67yHYgZWffQjuyhTDA=";
  };

  vendorHash = "sha256-t2lBPyCn8bu9hLsWmaCGir9egbX0mQR+8kB0RfY7nHE=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = plow;
  };

  meta = with lib; {
    description = "A high-performance HTTP benchmarking tool that includes a real-time web UI and terminal display";
    homepage = "https://github.com/six-ddc/plow";
    changelog = "https://github.com/six-ddc/plow/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ecklf ];
    mainProgram = "plow";
  };
}
