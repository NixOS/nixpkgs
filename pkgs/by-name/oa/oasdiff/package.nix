{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  stdenv,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "oasdiff";
  version = "1.35.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oasdiff";
    repo = "oasdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sd0uNzPFLKblnSivmNwRuTfHZa0uAQ9ztYaB+ze53QI=";
  };

  vendorHash = "sha256-ShHiN3pmMwZTc9Ai51CwWSXOKkxuUugbR9KOYZd4JIo=";

  subPackages = [ "." ];
  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/oasdiff/oasdiff/build.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  nativeCheckInputs = [ gitMinimal ];

  # The test suite starts local HTTP servers.
  __darwinAllowLocalNetworking = true;

  # subPackages selects only the executable, but tests live throughout the module.
  checkPhase = ''
    runHook preCheck

    export GOFLAGS=''${GOFLAGS//-trimpath/}
    go test -p "$NIX_BUILD_CORES" ./...

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram $out/bin/oasdiff \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd oasdiff \
      --bash <($out/bin/oasdiff completion bash) \
      --fish <($out/bin/oasdiff completion fish) \
      --zsh <($out/bin/oasdiff completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Find breaking changes in OpenAPI specifications";
    homepage = "https://github.com/oasdiff/oasdiff";
    changelog = "https://github.com/oasdiff/oasdiff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianhjr ];
    mainProgram = "oasdiff";
  };
})
