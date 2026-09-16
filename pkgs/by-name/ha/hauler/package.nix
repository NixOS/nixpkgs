{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "hauler";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "hauler-dev";
    repo = "hauler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8dELmDTkzcCcMQoA4+2l66o2unJhHMhq4HV8RYnn8h8=";
  };

  vendorHash = "sha256-KIaoSEY6sG67mgl6dzh3RtrNSJe1ZzgkN0/L9S/XviQ=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X hauler.dev/go/hauler/v2/internal/version.gitVersion=v${finalAttrs.version}"
    "-X hauler.dev/go/hauler/v2/internal/version.gitTreeState=clean"
  ];

  env.CGO_ENABLED = 0;

  # Skip test depending on network
  checkFlags = [
    "--skip"
    "TestNewChart/should_fetch_a_remote_chart"
  ];

  postInstall = ''
    installShellCompletion --cmd hauler \
      --bash <($out/bin/hauler completion bash) \
      --fish <($out/bin/hauler completion fish) \
      --zsh <($out/bin/hauler completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "hauler version";
      version = "v${finalAttrs.version}";
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "Airgap Swiss Army Knife";
    homepage = "https://hauler.dev";
    license = lib.licenses.asl20;
    mainProgram = "hauler";
    changelog = "https://github.com/hauler-dev/hauler/releases";
    maintainers = [ lib.maintainers.leonard2901 ];
  };
})
