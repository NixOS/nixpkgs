{
  stdenv,
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "hugo";
  version = "0.170.1";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1zE/qVOWdLvxAFiRBLyTPVC/WQCmBNO+55aOO4m4Y0s=";
  };

  vendorHash = "sha256-/V+JOA9TioksRWouV34Shf2PWX0+t4D1qfAetUghkGg=";

  checkFlags =
    let
      skippedTestPrefixes = [
        # Workaround for integration tests that reach out to the public
        # internet. Alternative option is to prefetch but it was decided
        # to continue to use ignores.
        # ref: https://github.com/NixOS/nixpkgs/pull/501960
        "TestCommands/mod"
        "TestCommands/hugo__static_issue14507"
        # Server tests are flaky, at least in x86_64-darwin. See #368072
        # We can try testing again after updating the `httpget` helper
        # ref: https://github.com/gohugoio/hugo/blob/v0.140.1/main_test.go#L220-L233
        "TestCommands/server"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "|^" skippedTestPrefixes}" ];

  proxyVendor = true;

  tags = [ "withdeploy" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=nixpkgs"
  ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      ${emulator} $out/bin/hugo gen man
      installManPage man/*
      installShellCompletion --cmd hugo \
        --bash <(${emulator} $out/bin/hugo completion bash) \
        --fish <(${emulator} $out/bin/hugo completion fish) \
        --zsh  <(${emulator} $out/bin/hugo completion zsh)
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/gohugoio/hugo/releases/tag/v${finalAttrs.version}";
    description = "Fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = lib.licenses.asl20;
    mainProgram = "hugo";
    maintainers = with lib.maintainers; [
      Frostman
      savtrip
      miniharinn
    ];
  };
})
