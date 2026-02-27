{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
,
}:

buildGoModule rec {
  pname = "adguard-exporter";
  version = "1.2.1";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "henrywhitaker3";
    repo = "adguard-exporter";
    sha256 = "sha256-OltYzxBOOcaW3oYNFvxxjG1qRvuLaZfReSeQaNGiRDc=";
  };

  vendorHash = "sha256-fDSR0+INsVBD5XauPdSETMNJZkrIbpKwZ/6Tb2Po4fY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${version}"
    "-X github.com/prometheus/common/version.Revision=${rev}"
    "-X github.com/prometheus/common/version.Branch=unknown"
    "-X github.com/prometheus/common/version.BuildUser=nix@nixpkgs"
    "-X github.com/prometheus/common/version.BuildDate=unknown"
  ];

  meta = with lib; {
    description = "A Prometheus exporter for AdGuard Home.";
    mainProgram = "adguard-exporter";
    homepage = "https://github.com/henrywhitaker3/adguard-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      fschn90
    ];
  };
}
