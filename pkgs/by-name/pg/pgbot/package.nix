{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "pgbot";
  version = "0.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pgrundev";
    repo = "pgbot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QJWJTSS92g7Ay2r5yckbRX5/JOUIBDTKGXpEzerZyKI=";
  };

  vendorHash = "sha256-iN6SE0ehjVVXkw8hHsUrCNXPV1Xchw6gxt92kVCQTV4=";

  subPackages = [ "cmd/pgbot" ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  checkPhase = ''
    runHook preCheck
    export GOFLAGS="''${GOFLAGS//-trimpath/}"
    go test -p "$NIX_BUILD_CORES" ./...
    runHook postCheck
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pgbot \
      --bash <($out/bin/pgbot completion bash) \
      --fish <($out/bin/pgbot completion fish) \
      --zsh <($out/bin/pgbot completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "In-database observability for PostgreSQL";
    homepage = "https://pgbot.dev";
    changelog = "https://github.com/pgrundev/pgbot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kevinpita ];
    mainProgram = "pgbot";
  };
})
