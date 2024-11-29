{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mmdbinspect";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "mmdbinspect";
    rev = "refs/tags/v${version}";
    hash = "sha256-PYn+NgJDZBP+9nIU0kxg9KYT0EV35omagspcsCpa9DM=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-HNgofsfMsqXttnrNDIPgLHag+2hqQTREomcesWldpMo=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Look up records for one or more IPs/networks in one or more .mmdb databases";
    homepage = "https://github.com/maxmind/mmdbinspect";
    changelog = "https://github.com/maxmind/mmdbinspect/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mmdbinspect";
  };
}
