{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumi-esc";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${version}";
    hash = "sha256-TsYMGPL4Lru7T1p4v/gaql665JO2LIKayb3GupxYbiI=";
  };

  subPackages = "cmd/esc";

  vendorHash = "sha256-IcQaWo5/EoPJjn5pDKwHjd56JeareznE7iSansJIfso=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/esc/cmd/esc/cli/version.Version=${src.rev}"
  ];

  meta = with lib; {
    description = "Pulumi ESC (Environments, Secrets, and Configuration) for cloud applications and infrastructure";
    homepage = "https://github.com/pulumi/esc/tree/main";
    changelog = "https://github.com/pulumi/esc/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    mainProgram = "esc";
  };
}
