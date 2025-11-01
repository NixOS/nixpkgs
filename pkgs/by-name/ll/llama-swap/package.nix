{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,

  callPackage,

  nixosTests,
  nix-update-script,
}:

let
  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
buildGoModule (finalAttrs: {
  pname = "llama-swap";
  version = "170";

  outputs = [
    "out"
    "wol" # wake on lan proxy
  ];

  src = fetchFromGitHub {
    owner = "mostlygeek";
    repo = "llama-swap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5GNK/Xze9yZnXg5lc+ym7GvRU1/4HX2m8SgJbcg270I=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+'%Y-%m-%dT%H:%M:%SZ'" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-5mmciFAGe8ZEIQvXejhYN+ocJL3wOVwevIieDuokhGU=";

  passthru.ui = callPackage ./ui.nix { llama-swap = finalAttrs.finalPackage; };

  nativeBuildInputs = [
    versionCheckHook
  ];

  # required for testing
  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    # ldflags based on metadata from git and source
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE_EPOCH)"

    # copy for go:embed in proxy/ui_embed.go
    cp -r ${finalAttrs.passthru.ui}/ui_dist proxy/
  '';

  excludedPackages = [
    # regression testing tool
    "misc/process-cmd-test"
    # benchmark/regression testing tool
    "misc/benchmark-chatcompletion"
  ]
  ++ lib.optionals (!canExecute) [
    # some tests expect to execute `simple-something`; if it can't be executed
    # it's unneeded
    "misc/simple-responder"
  ];

  checkFlags =
    let
      skippedTests = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
        # Fail only on x86_64-darwin intermittently
        # https://github.com/mostlygeek/llama-swap/issues/320
        "TestProcess_AutomaticallyStartsUpstream"
        "TestProcess_WaitOnMultipleStarts"
        "TestProcess_BrokenModelConfig"
        "TestProcess_UnloadAfterTTL"
        "TestProcess_LowTTLValue"
        "TestProcess_HTTPRequestsHaveTimeToFinish"
        "TestProcess_SwapState"
        "TestProcess_ShutdownInterruptsHealthCheck"
        "TestProcess_ExitInterruptsHealthCheck"
        "TestProcess_ConcurrencyLimit"
        "TestProcess_StopImmediately"
        "TestProcess_ForceStopWithKill"
        "TestProcess_StopCmd"
        "TestProcess_EnvironmentSetCorrectly"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  # some tests expect to execute `simple-something` and proxy/helpers_test.go
  # checks the file exists
  doCheck = canExecute;
  preCheck = ''
    mkdir build
    ln -s "$GOPATH/bin/simple-responder" "./build/simple-responder_''${GOOS}_''${GOARCH}"
  '';
  postCheck = ''
    rm "$GOPATH/bin/simple-responder"
  '';

  postInstall = ''
    install -Dm444 -t "$out/share/llama-swap" config.example.yaml
    mkdir -p "$wol/bin"
    mv "$out/bin/wol-proxy" "$wol/bin/"
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  passthru.tests.nixos = nixosTests.llama-swap;
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "ui"
    ];
  };

  meta = {
    homepage = "https://github.com/mostlygeek/llama-swap";
    changelog = "https://github.com/mostlygeek/llama-swap/releases/tag/${finalAttrs.src.tag}";
    description = "Model swapping for llama.cpp (or any local OpenAPI compatible server)";
    longDescription = ''
      llama-swap is a light weight, transparent proxy server that provides
      automatic model swapping to llama.cpp's server.

      When a request is made to an OpenAI compatible endpoint, llama-swap will
      extract the `model` value and load the appropriate server configuration to
      serve it. If the wrong upstream server is running, it will be replaced
      with the correct one. This is where the "swap" part comes in. The upstream
      server is automatically swapped to the correct one to serve the request.

      In the most basic configuration llama-swap handles one model at a time.
      For more advanced use cases, the `groups` feature allows multiple models
      to be loaded at the same time. You have complete control over how your
      system resources are used.
    '';
    license = lib.licenses.mit;
    mainProgram = "llama-swap";
    maintainers = with lib.maintainers; [
      jk
      podium868909
    ];
  };
})
