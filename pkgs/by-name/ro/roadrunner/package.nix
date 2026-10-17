{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "roadrunner";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "roadrunner-server";
    repo = "roadrunner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SQs/QOZ3j+PGS9iJ4TW/RmBWCZPxNxqnV5192FvEqxc=";
  };

  vendorHash = "sha256-LYHjx3ur1Qf0FPsndSKQNa04gursoAPv/Hdbt1+vsUg=";
  env.GOWORK = "off";

  subPackages = [ "cmd/rr" ];

  # Flags as provided by the build automation of the project:
  # https://github.com/roadrunner-server/roadrunner/blob/c8f9cfd9510b748238b2fc6dd009ad3726f09e36/.github/workflows/release.yml#L82
  ldflags = [
    "-s"
    "-X=github.com/roadrunner-server/roadrunner/v${lib.versions.major finalAttrs.version}/internal/meta.version=${finalAttrs.version}"
    "-X=github.com/roadrunner-server/roadrunner/v${lib.versions.major finalAttrs.version}/internal/meta.buildTime=1970-01-01T00:00:00Z"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rr \
      --bash <($out/bin/rr completion bash) \
      --zsh <($out/bin/rr completion zsh) \
      --fish <($out/bin/rr completion fish)
  '';

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/roadrunner-server/roadrunner/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "High-performance PHP application server, process manager written in Go and powered with plugins";
    homepage = "https://roadrunner.dev";
    license = lib.licenses.mit;
    mainProgram = "rr";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
