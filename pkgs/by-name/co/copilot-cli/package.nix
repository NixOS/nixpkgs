{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  copilot-cli,
}:

buildGoModule rec {
  pname = "copilot-cli";
  version = "1.34.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "copilot-cli";
    rev = "v${version}";
    hash = "sha256-Oxt1+0z+woNPsFuCkj4t71/e21mHtoCd281BwbHCGc8=";
  };

  vendorHash = "sha256-ZdYuQAdjzvxxqKHoiHfhfJff3OfEE7ciIGcX1W3jVXY=";

  nativeBuildInputs = [ installShellFiles ];

  # follow LINKER_FLAGS in Makefile
  ldflags = [
    "-s"
    "-w"
    "-X github.com/aws/copilot-cli/internal/pkg/version.Version=v${version}"
    "-X github.com/aws/copilot-cli/internal/pkg/cli.binaryS3BucketPath=https://ecs-cli-v2-release.s3.amazonaws.com"
  ];

  subPackages = [ "./cmd/copilot" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd copilot \
      --bash <($out/bin/copilot completion bash) \
      --fish <($out/bin/copilot completion fish) \
      --zsh <($out/bin/copilot completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = copilot-cli;
    command = "copilot version";
    version = "v${version}";
  };

  meta = {
    description = "Build, Release and Operate Containerized Applications on AWS";
    homepage = "https://github.com/aws/copilot-cli";
    changelog = "https://github.com/aws/copilot-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jiegec ];
    mainProgram = "copilot";
  };
}
