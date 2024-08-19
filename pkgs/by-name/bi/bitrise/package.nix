{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "bitrise";
  version = "2.19.0";

  src = fetchFromGitHub {
    owner = "bitrise-io";
    repo = "bitrise";
    rev = version;
    hash = "sha256-VjuDeRl/rqA7bdhn9REdxdjRon5WxHkFIveOYNpQqa8=";
  };

  checkFlags = ["-v" "-timeout 20s" "-skip=^Test(SkipIfEmpty|DeleteEnvironment|StepOutputsInTemplate|FailedStepOutputs|BitriseSourceDir|EnvOrders|0Steps1Workflows|1Workflows|3Workflows|BuildStatusEnv|Fail|BuildFailedMode|WorkflowEnvironments|WorkflowEnvironmentOverWrite|TargetDefinedWorkflowEnvironment|StepInputEnvironment|StepOutputEnvironment|ExpandEnvs|EvaluateInputs|InvalidStepID|PluginTriggered|BuildFailedModeForStepBundles|Success|ParseAndValidatePluginFromYML|DownloadPluginBin|ClonePluginSrc|StepmanJSONStepLibStepInfo|MoveFileDifferentDevices|0Steps3WorkflowsBeforeAfter|InitPaths)$"];

  vendorHash = null;
  ldflags = [
    "-X github.com/bitrise-io/bitrise/version.Commit=${src.rev}"
    "-X github.com/bitrise-io/bitrise/version.BuildNumber=0"
  ];
  CGO_ENABLED = 0;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/bitrise-io/bitrise/releases";
    description = "CLI for running your Workflows from Bitrise on your local machine";
    homepage = "https://bitrise.io/cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "bitrise";
    maintainers = with lib.maintainers; [ ofalvai ];
  };
}
