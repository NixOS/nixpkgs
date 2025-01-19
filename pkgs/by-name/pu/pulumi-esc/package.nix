{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumi-esc";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${version}";
    hash = "sha256-Bzg3MFxyyu6CUvwrHSScg9aEJ7JQbL/YICRbn4Zjc3s=";
  };

  subPackages = "cmd/esc";

  vendorHash = "sha256-T9DUgfYpu1xXekMxzlr2VwmPSkD/sPml+G0KaFeeAWA=";

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
    maintainers = with maintainers; [ yomaq ];
    mainProgram = "esc";
  };
}
