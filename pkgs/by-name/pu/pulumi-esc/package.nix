{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pulumi-esc";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${version}";
    hash = "sha256-9K7pP4MOShHPTxTuKaUMY87Z4rDkGHrV9Ds1guUpFqM=";
  };

  subPackages = "cmd/esc";

  vendorHash = "sha256-uVw8jc7dZOHdJt9uVDJGaJWkD7dz0rQ3W1pJXSrcW5w=";

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
