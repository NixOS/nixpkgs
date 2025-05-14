{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  harbor-cli,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "harbor-cli";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "goharbor";
    repo = "harbor-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oTZhwF4DOTMAHzCide795Q+djPTzyn5Zj0Ov/3P4lAQ=";
  };

  vendorHash = "sha256-rGWGRPahJg9AtGXCmCbKTzrhIIP6ejyoMryyV7jSUZw=";

  excludedPackages = [
    "dagger"
    "doc"
  ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=${finalAttrs.version}"
  ];

  doCheck = false; # Network required

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME="$(mktemp -d)"

    installShellCompletion --cmd harbor \
      --bash <($out/bin/harbor completion bash) \
      --fish <($out/bin/harbor completion fish) \
      --zsh <($out/bin/harbor completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = harbor-cli;
    command = "HOME=\"$(mktemp -d)\" harbor version";
  };

  meta = {
    homepage = "https://github.com/goharbor/harbor-cli";
    description = "Command-line tool facilitates seamless interaction with the Harbor container registry";
    changelog = "https://github.com/goharbor/harbor-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "harbor";
  };
})
