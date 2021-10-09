{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "k0sctl";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-22jZWRnymIYN1LlGOo8abVx8DTUe9VK1xAHddLknt6A=";
  };

  vendorSha256 = "sha256-N4cU9wzBRZn71mZHkNDXKgSXvlN2QFS6K4MtlR25DJc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/k0sproject/k0sctl/version.Version=${version}"
  ];

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
