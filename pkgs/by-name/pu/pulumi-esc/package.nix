{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumi-esc";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${version}";
    hash = "sha256-ZS5mwRua/IYAhA5W+EEZxttArTm+vLArA1RM8SFOK60=";
  };

  subPackages = "cmd/esc";

  vendorHash = "sha256-IcQaWo5/EoPJjn5pDKwHjd56JeareznE7iSansJIfso=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/esc/cmd/esc/cli/version.Version=${src.rev}"
  ];

  meta = {
    description = "Pulumi ESC (Environments, Secrets, and Configuration) for cloud applications and infrastructure";
    homepage = "https://github.com/pulumi/esc/tree/main";
    changelog = "https://github.com/pulumi/esc/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "esc";
  };
}
