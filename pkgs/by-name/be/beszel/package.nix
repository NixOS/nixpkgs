{
  stdenv,
  buildGo126Module,
  lib,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  buildNpmPackage,
  nixosTests,
}:
buildGo126Module (finalAttrs: {
  pname = "beszel";
  version = "0.18.7";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pVZ1ru9++BypZ3EwoE8clqJowXj1/CMiJxKaC+UY9VE=";
  };

  webui = buildNpmPackage {
    inherit (finalAttrs)
      pname
      version
      src
      meta
      ;

    npmFlags = [ "--legacy-peer-deps" ];

    buildPhase = ''
      runHook preBuild

      npx lingui extract --overwrite
      npx lingui compile
      node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';

    sourceRoot = "${finalAttrs.src.name}/internal/site";

    npmDepsHash = "sha256-mYAD8FrQwa+F/VgGxFpe8vqucfZaM0PmY+gJJqw1IKk=";
  };

  vendorHash = "sha256-TVpZbK9V9/GqpVFcjF7QGD5XJJHzRgjVXZOImHQTR1k=";

  patches = [
    # https://github.com/NixOS/nixpkgs/pull/513197
    (fetchpatch {
      name = "fix-updater-after-system-manager-shutdown.patch";
      url = "https://github.com/henrygd/beszel/commit/c538d1de1cf3f4664a2d98086341884a217846e7.patch";
      hash = "sha256-voIT9b14pgfhnbJrqgoIbQtwZPU1JF0fblybjG9mzvM=";
    })
  ];

  preBuild = ''
    mkdir -p internal/site/dist
    cp -r ${finalAttrs.webui}/* internal/site/dist
  '';

  checkFlags =
    let
      skippedTests = [
        "TestCollectorStartHelpers/nvtop_collector"
        "TestApiRoutesAuthentication/GET_/update_-_shouldn't_exist_without_CHECK_UPDATES_env_var"
        "TestConfigSyncWithTokens"
        # This subtest assumes enough host CPUs for an 8s CPU delta over 1s to stay below 100%.
        "TestServiceUpdateCPUPercent/subsequent_call_calculates_CPU_percentage"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "TestCollectorStartHelpers/nvidia-smi_collector"
        "TestCollectorStartHelpers/rocm-smi_collector"
        "TestCollectorStartHelpers/tegrastats_collector"
        "TestNewGPUManagerPriorityNvtopFallback"
        "TestNewGPUManagerPriorityMixedCollectors"
        "TestNewGPUManagerPriorityNvmlFallbackToNvidiaSmi"
        "TestNewGPUManagerConfiguredCollectorsMustStart"
        "TestNewGPUManagerConfiguredNvmlBypassesCapabilityGate"
        "TestNewGPUManagerJetsonIgnoresCollectorConfig"
      ];
    in
    [
      "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
      "-tags=testing"
    ];

  postInstall = ''
    mv $out/bin/agent $out/bin/beszel-agent
    mv $out/bin/hub $out/bin/beszel-hub
  '';

  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "webui"
      ];
    };
    tests.nixos = nixosTests.beszel;
  };

  meta = {
    homepage = "https://github.com/henrygd/beszel";
    changelog = "https://github.com/henrygd/beszel/releases/tag/v${finalAttrs.version}";
    description = "Lightweight server monitoring hub with historical data, docker stats, and alerts";
    maintainers = with lib.maintainers; [
      bot-wxt1221
      arunoruto
      BonusPlay
    ];
    license = lib.licenses.mit;
  };
})
