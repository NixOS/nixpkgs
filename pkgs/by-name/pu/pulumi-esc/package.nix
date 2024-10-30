{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumi-esc";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${version}";
    hash = "sha256-/H2HFjq/CpY5/xj9tqr+1Qo1nD06joahvbIiu16DLrs=";
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
