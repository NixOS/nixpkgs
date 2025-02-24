{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumi-esc";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${version}";
    hash = "sha256-X6QX2bCvHwxIXw1Z1PE4bfLphJCSVW1os9pQyZAdTnk=";
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
