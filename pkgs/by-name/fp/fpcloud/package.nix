{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "fpcloud";
  version = "0.131.0";

  src = fetchFromGitHub {
    owner = "fogpipe";
    repo = "cloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wm8HUXYZ+Vj/OaAngdVU0MCeyrzZJ0gv4hp34QCrztg=";
  };

  vendorHash = "sha256-txsSh5vq1/5bXC55My+vYTr7nGnRE6d18tY3UUvyfnM=";

  subPackages = [ "cmd/fpcloud" ];

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fpcloud \
      --bash <($out/bin/fpcloud completion bash) \
      --zsh <($out/bin/fpcloud completion zsh) \
      --fish <($out/bin/fpcloud completion fish)
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/fogpipe/cloud-cli/pkg/cli.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Command-line interface for the Fogpipe Cloud platform";
    homepage = "https://github.com/fogpipe/cloud-cli";
    changelog = "https://github.com/fogpipe/cloud-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      phelian
      lorentzlasson
    ];
    mainProgram = "fpcloud";
    platforms = lib.platforms.unix;
  };
})
