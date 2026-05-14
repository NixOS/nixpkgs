{
  lib,
  stdenv,
  buildGoModule,
  docker,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  oras,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "copacetic";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "project-copacetic";
    repo = "copacetic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FTldgBYOmJt3VIC3vwp415oPNRCAiR1cxEF8lJr5TSU=";
  };

  vendorHash = "sha256-nkVAHqe61AR0GBK5upsk650kl8UDp1ppFWhyi3erpr4=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    docker
    oras
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/project-copacetic/copacetic/pkg/version.GitVersion=${finalAttrs.version}"
    "-X=main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  checkFlags =
    let
      # Skip tests that require network access and container services
      skippedTests = [
        "TestNewClient/custom_buildkit_addr"
        "TestPatch"
        "TestPlugins/docker.io"
        "TestPatchPartialArchitectures"
        "TestPushToRegistry"
        "TestMultiPlatformPluginPatch"
        "TestPodmanLoader_Load_Success"
        "TestMultiArchBulkPatching"
        "TestComprehensiveBulkPatching"
        "TestTrivyParserParseWithNodeJS/OS_and_Node.js_packages"
        "TestLocalImageDescriptor"
        "TestGetImageDescriptor"
        "TestDotNetSDKImagePatching"
        "TestGenerateWithoutReport"
        "TestGenerateToStdout"
        "TestCustomBuildPatching"
        "TestNodeJSPatching"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  postInstall = ''
    mv $out/bin/copacetic $out/bin/copa
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd copa \
      --bash <($out/bin/copa completion bash) \
      --fish <($out/bin/copa completion fish) \
      --zsh <($out/bin/copa completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for directly patching vulnerabilities in container images";
    homepage = "https://project-copacetic.github.io/copacetic/";
    changelog = "https://github.com/project-copacetic/copacetic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "copa";
    maintainers = with lib.maintainers; [ tbutter ];
  };
})
