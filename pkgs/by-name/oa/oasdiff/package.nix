{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  makeWrapper,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "oasdiff";
  version = "1.37.0";

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oasdiff";
    repo = "oasdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ay9bhSOVIGfO4FTyzldVPnfhAx4jLKsOmXcQMgEm6J4=";
  };

  vendorHash = "sha256-tJQZkSqZtLeQ0exRgMYocSh6N/iexk5Lw0uEOhnIqsM=";

  subPackages = [ "." ];

  env = {
    CGO_ENABLED = 0;
    GOFLAGS = "-trimpath";
  };

  ldflags = [
    "-s"
    "-X github.com/oasdiff/oasdiff/build.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  nativeCheckInputs = [ gitMinimal ];

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find breaking changes in OpenAPI specifications";
    homepage = "https://github.com/oasdiff/oasdiff";
    changelog = "https://github.com/oasdiff/oasdiff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianhjr ];
    mainProgram = "oasdiff";
  };
})
