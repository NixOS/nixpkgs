{ lib, go, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-cXU+LnOCsGg+iwH5c7cKVi2Htw45AGxyjJFKXKbTkUo=";
  };

  vendorSha256 = "sha256-CiVAzFN/ygIiyhZKYtJ197TZO3ppL/emWSj4hAlIanc=";

  doCheck = false;

  ldflags = [
    "-s" "-w"
    "-X github.com/splunk/qbec/internal/commands.version=${version}"
    "-X github.com/splunk/qbec/internal/commands.commit=${src.rev}"
    "-X github.com/splunk/qbec/internal/commands.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
