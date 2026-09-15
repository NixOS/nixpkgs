{
  lib,
  stdenv,

  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,

  callPackage,

  bash,

  nixosTests,
  nix-update-script,

  withUI ? true,
}:

let
  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
buildGo127Module (finalAttrs: {
  pname = "llama-swap";
  version = "253";

  outputs = [
    "out"
    "wol" # wake on lan proxy
    "vllm_wrapper" # helper for using `vllm` with `--enable-sleep-mode`
    "utils"
  ];

  src = fetchFromGitHub {
    owner = "mostlygeek";
    repo = "llama-swap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ScD16a10vnVnKhEgCHQP8SuBIBqr82XsWr+luvznImM=";
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

  vendorHash = "sha256-QIZOduNzikWiVf58BrtW1LPKMAhKeU4jvovSDblzqbE=";

  # Upstream only embeds the UI when this build tag is set.
  tags = lib.optionals withUI [ "embed_ui" ];

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

  postPatch = ''
    substituteInPlace internal/process/process_command_forking_test.go \
      --replace-fail "#!/bin/bash" "#!${lib.getExe bash}"
    substituteInPlace cmd/vllm-wrapper/main_test.go \
      --replace-fail "#!/bin/bash" "#!${lib.getExe bash}"
  '';

  preBuild = ''
    # ldflags based on metadata from git and source
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE_EPOCH)"

    ${lib.optionalString withUI ''
      # copy for go:embed in internal/server/ui_embed.go
      cp -r ${finalAttrs.passthru.ui}/ui_dist internal/server/
    ''}
  '';

  excludedPackages = [
    # regression testing tool
    "misc/process-cmd-test"
    # benchmark/regression testing tool
    "misc/benchmark-chatcompletion"
    # testing tool for the performance monitoring code
    "cmd/monitor-test"
  ]
  ++ lib.optionals finalAttrs.doCheck [
    # some tests expect to execute `simple-something`; if it can't be executed
    # it's unneeded
    "misc/simple-responder"
  ];

  checkFlags =
    let
      skippedTests = lib.optionals stdenv.hostPlatform.isDarwin [
        # Fail only on *-darwin intermittently
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
        "TestProcess_ReverseProxyPanicIsHandled"
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
  # doesn't need to be cleaned up outside of the check path as we don't build it
  # due to `excludedPackages`
  postCheck = ''
    rm "$GOPATH/bin/simple-responder"
  '';

  # project regularly adds small utility binaries
  # this `installPhase` means we need to sort them
  # into outputs or skip building them
  installPhase = ''
    runHook preInstall

    install -Dm444 -t "$out/share/llama-swap" config.example.yaml

    mkdir -p "$out/bin"
    mv "$GOPATH/bin/llama-swap" "$out/bin/"

    mkdir -p "$wol/bin"
    mv "$GOPATH/bin/wol-proxy" "$wol/bin/"

    mkdir -p "$vllm_wrapper/bin"
    mv "$GOPATH/bin/vllm-wrapper" "$vllm_wrapper/bin/"

    mkdir -p "$utils/bin"
    mv "$GOPATH/bin/"{fake-model,test-concurrency} "$utils/bin/"

    # log if we don't handle a new executable
    EXECUTABLES=$(find "$GOPATH/bin" -maxdepth 1 -type f -executable -print -quit)
    if [ -n "$EXECUTABLES" ]; then
      echo "Error: Directory '$GOPATH/bin' still contains executables." >&2
      echo "  $EXECUTABLES" >&2
      exit 1
    fi

    runHook postInstall
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  passthru.tests.nixos = if withUI then nixosTests.llama-swap.full else nixosTests.llama-swap.minimal;
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "ui"
    ];
  };

  __structuredAttrs = true;

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
