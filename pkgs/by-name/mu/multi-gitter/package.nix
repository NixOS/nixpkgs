{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  stdenv,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "multi-gitter";
  version = "0.63.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lindell";
    repo = "multi-gitter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uwq6xHOb8LvWdbkxbOVxE6O6o89O+ZGLgGeDFhj2/2s=";
  };

  vendorHash = "sha256-1D8OUCxp6ATmomWHbrtAk+pA18GOGytN6voS/ywk6Ak=";

  # the below packages compile into development and testing utilities
  excludedPackages = [
    "tools/docs"
    "tools/readme-docs"
    "tests/scripts/adder"
    "tests/scripts/changer"
    "tests/scripts/manual-committer"
    "tests/scripts/printer"
    "tests/scripts/pwd"
    "tests/scripts/remover"
  ];

  nativeCheckInputs = [ gitMinimal ];

  # These subtests assume macOS /private symlink resolution for TMPDIR,
  # which doesn't hold in the Nix build sandbox.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-skip=TestTable/go_custom_clone_dir_with_absolute_path|TestTable/cmd_custom_clone_dir_with_absolute_path"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=unknown"
    "-X main.date=unknown"
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd multi-gitter \
      --bash <($out/bin/multi-gitter completion bash) \
      --fish <($out/bin/multi-gitter completion fish) \
      --zsh <($out/bin/multi-gitter completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "multi-gitter version";
  };

  meta = {
    description = "Update multiple repositories in bulk with one command";
    homepage = "https://github.com/lindell/multi-gitter";
    changelog = "https://github.com/lindell/multi-gitter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t-monaghan ];
    mainProgram = "multi-gitter";
  };
})
