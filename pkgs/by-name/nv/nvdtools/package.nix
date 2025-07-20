{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nvdtools";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "nvdtools";
    tag = "v${version}";
    hash = "sha256-uB7dfqGaoP9Xx04BykscIFQ2rckaMaj93gh5mhgMqfw=";
  };

  vendorHash = "sha256-DzhP42DaddIm+/Z3a83rWX5WY+tM1P+vBNe6B91L7E8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tools to work with the feeds (vulnerabilities, CPE dictionary etc.) distributed by National Vulnerability Database";
    homepage = "https://github.com/facebookincubator/nvdtools";
    changelog = "https://github.com/facebookincubator/nvdtools/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
