{
  stdenv,
  buildGo127Module,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  nixosTests,
}:
buildGo127Module (finalAttrs: {
  pname = "beszel";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KwC94IeXZtb8ygKxQR86dy+MyrwGu/aa2t+rmpD+0IE=";
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

  vendorHash = "sha256-HhkqTQpmf8EQ9/fJN56OTovI+Zufxxy/tuNH6Z+mxC4=";

  preBuild = ''
    mkdir -p internal/site/dist
    cp -r ${finalAttrs.webui}/* internal/site/dist
  '';

  checkFlags =
    let
      skippedTests = [
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
      "-tags=testing,no_ui"
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
