{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "roborev";
  version = "0.46.1";

  src = fetchFromGitHub {
    owner = "roborev-dev";
    repo = "roborev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E5AcXd63sNRoRc8SCVlV5Jv5arjgpCR/8knZHJ8UG0k=";
  };

  vendorHash = "sha256-chHhETsoDGJEw1CijPmKEVUIc5dhwGytFBFCWuO5GRY=";

  subPackages = [ "cmd/roborev" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/roborev-dev/roborev/internal/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd roborev \
      --bash <($out/bin/roborev completion bash) \
      --fish <($out/bin/roborev completion fish) \
      --zsh <($out/bin/roborev completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.meta.mainProgram} version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Continuous background code review for coding agents";
    homepage = "https://github.com/roborev-dev/roborev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "roborev";
  };
})
