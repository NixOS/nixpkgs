{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "draft";
  version = "0.17.15";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "draft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n5VZjQBSmVC06drEW9x+OhRSgxWacEwlXH8jg48iEoE=";
  };

  vendorHash = "sha256-rtLwvo0vTQZ1ukZYiv/kXOa/m87y49sSPc8c1C6cdTI=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [ installShellFiles ];

  checkFlags =
    let
      skippedTests = [
        # Tries to HTTP GET https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/pod-v1.json
        "TestCreateK8sFileMatchesValidFile"
        "TestCreateK8sFileMatchesInvalidFile"
        "TestCreateK8sFileMatchesNestedValidFile"
        "TestCreateK8sFileMatchesNestedInvalidFile"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd draft \
      --bash <($out/bin/draft completion bash) \
      --fish <($out/bin/draft completion fish) \
      --zsh <($out/bin/draft completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A day 0 tool for getting your app on k8s fast";
    homepage = "https://github.com/Azure/draft";
    changelog = "https://github.com/Azure/draft/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "draft";
  };
})
