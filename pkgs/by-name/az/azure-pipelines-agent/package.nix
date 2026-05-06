{
  bash,
  buildDotnetModule,
  coreutils,
  dotnetCorePackages,
  fetchFromGitHub,
  gitMinimal,
  glibc,
  glibcLocales,
  icu,
  krb5,
  lib,
  nodejs_20,
  openssl,
  stdenv,
  which,
  zlib,
}:
buildDotnetModule (finalAttrs: {
  pname = "azure-pipelines-agent";
  version = "4.272.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "azure-pipelines-agent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W9K3KkxM63SxKqqma6LVLEW74msz5nRGV8pn+I0Mkug=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  env = {
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = isNull glibcLocales;
  }
  // lib.optionalAttrs (!(isNull glibcLocales)) {
    LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
  };

  patches = [
    ./patches/dont-install-service.patch
    ./patches/env-sh-use-runner-root.patch
    ./patches/fix-logging-cs-create-folder.patch
    ./patches/host-context-dirs.patch
    ./patches/no-wrap-libicu.patch
    ./patches/use-get-directory-for-diag.patch
    ./patches/fix-license-dir.patch
  ];

  preConfigure = ''
    # Generate src/Microsoft.VisualStudio.Services.Agent/BuildConstants.cs
    dotnet msbuild \
      -t:GenerateConstant \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      -p:PackageRuntime="${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}" \
        -p:AgentVersion="${finalAttrs.version}" \
      src/dir.proj
  '';

  nativeBuildInputs = [
    which
    gitMinimal
    openssl
    krb5
    icu
    zlib
    coreutils
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    bash
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetFlags = [
    "-p:PackageRuntime=${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}"
    "-p:TargetFramework=net8.0"
  ];

  projectFile = [
    "src/Agent.Sdk/Agent.Sdk.csproj"
    "src/Agent.Listener/Agent.Listener.csproj"
    "src/Microsoft.VisualStudio.Services.Agent/Microsoft.VisualStudio.Services.Agent.csproj"
    "src/Agent.Worker/Agent.Worker.csproj"
    "src/Agent.PluginHost/Agent.PluginHost.csproj"
    "src/Agent.Plugins/Agent.Plugins.csproj"
  ];
  nugetDeps = ./deps.json;

  strictDeps = true;
  __structuredAttrs = true;

  preCheck = ''
    mkdir -p _layout/externals
    ln -s ${nodejs_20} _layout/externals/node20_1
  '';

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/${finalAttrs.pname}/en-US

    install -m755 src/Misc/layoutbin/AgentService.js          $out/lib/${finalAttrs.pname}
    install -m755 src/Misc/layoutbin/en-US/strings.json       $out/lib/${finalAttrs.pname}/en-US
    install -m755 src/Misc/layoutbin/runsvc.sh                $out/lib/${finalAttrs.pname}
    install -m755 src/Misc/layoutroot/config.sh               $out/lib/${finalAttrs.pname}
    install -m755 src/Misc/layoutroot/env.sh                  $out/lib/${finalAttrs.pname}
    install -m755 src/Misc/layoutroot/license.html            $out/lib/${finalAttrs.pname}
    install -m755 src/Misc/layoutroot/reauth.sh               $out/lib/${finalAttrs.pname}
    install -m755 src/Misc/layoutroot/run.sh                  $out/lib/${finalAttrs.pname}

    # env.sh is patched to not require any wrapping
    ln -sr "$out/lib/${finalAttrs.pname}/env.sh" "$out/bin/"

    substituteInPlace $out/lib/${finalAttrs.pname}/config.sh \
      --replace-fail './bin/Agent.Listener' "$out/bin/Agent.Listener"

    substituteInPlace $out/lib/${finalAttrs.pname}/run.sh \
      --replace-fail '"$DIR"/bin/' '"$DIR"/'

    substituteInPlace $out/lib/${finalAttrs.pname}/config.sh \
      --replace-fail 'command -v ldd' 'command -v ${glibc.bin}/bin/ldd' \
      --replace-fail 'ldd ./bin' '${glibc.bin}/bin/ldd ${finalAttrs.dotnet-runtime}/share/dotnet/shared/Microsoft.NETCore.App/${finalAttrs.dotnet-runtime.version}/' \
      --replace-fail '/sbin/ldconfig' '${glibc.bin}/bin/ldconfig'

    # Make paths absolute
    substituteInPlace $out/lib/${finalAttrs.pname}/runsvc.sh \
      --replace-fail './externals' "$out/lib/externals" \
      --replace-fail './bin/AgentService.js' "$out/lib/${finalAttrs.pname}/AgentService.js"

    # The upstream package includes Node and expects it at the path
    # externals/node$version. As opposed to the official releases, we don't
    # link the Alpine Node flavors.
    mkdir -p $out/lib/externals
    ln -s ${nodejs_20} $out/lib/externals/node20_1

    # Common wrapper args for executables
    makeWrapperArgs+=(
      --run 'export AGENT_ROOT="''${AGENT_ROOT:-"$HOME/.azure-agent"}"'
      --run 'mkdir -p "$AGENT_ROOT"'
      --chdir "$out"
    )
  '';

  executables = [
    "Agent.Listener"
    "Agent.PluginHost"
    "Agent.Worker"
    "config.sh"
    "run.sh"
    "runsvc.sh"
  ];

  doCheck = true;
  testProjectFile = [ "src/Test/Test.csproj" ];
  disabledTests =
    map (x: "Microsoft.VisualStudio.Services.Agent.Tests.${x}") [
      "ConstantGenerationL0.ReleaseBuiltFromGitNotFromTarball"
      "HostContextL0.LogFileChangedAccordingToEnvVariable"
      "L0.Util.WindowsProcessUtilL0.Test_GetProcessList"
      "L1.Worker.CheckoutL1Tests.NoCheckout"
      "L1.Worker.ConditionsL1Tests.Conditions_Failed"
      "L1.Worker.ConfigL1Tests.TrackingConfigsShouldBeConsistentAcrossMulticheckoutRuns"
      "L1.Worker.ConfigL1Tests.TrackingConfigsShouldBeConsistentAcrossRuns"
      "L1.Worker.ConfigL1Tests.TrackingConfigsShouldBeConsistentAcrossRunsWithDifferentCheckouts"
      "L1.Worker.ContainerL1Tests.StepTarget_RestrictedMode"
      "L1.Worker.CoreL1Tests.Input_HandlesTrailingSpace"
      "L1.Worker.CoreL1Tests.Test_Base"
      "L1.Worker.CoreL1Tests.Test_Base_Node20"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_EmptyStepName_StillHasValidCorrelation"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_InitializeAndFinalize_HaveUniqueCorrelations"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_JobWithVariables_CorrelationNotAffectedByVariables"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_LongRunningJob_CorrelationPersistsThroughout"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_MultipleSteps_EachStepHasUniqueCorrelation"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_PostJobSteps_HaveCorrelation"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_SingleStepJob_HasCorrelationInLogs"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_StepWithOutput_CorrelationInOutputLogs"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_TimelineRecords_ContainStepIdentifiers"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_WithCheckout_CheckoutStepHasCorrelation"
      "L1.Worker.CorrelationL1Tests.CorrelationContext_WithoutEnhancedLogging_StillHasStepIds"
      "L1.Worker.TimeoutLogFlushingL1Tests.TestTimeoutLogFlushingDisabled_JobTimesOutWithExpectedResult"
      "L1.Worker.TimeoutLogFlushingL1Tests.TestTimeoutLogFlushingEnabled_JobCompletesSuccessfully"
      "L1.Worker.TimeoutLogFlushingL1Tests.TestTimeoutLogFlushingEnabled_JobTimesOutWithExpectedResult"
      "L1.Worker.TimeoutLogFlushingL1Tests.TestTimeoutLogFlushingEnvironmentVariableValues_HandlesVariousInputs"
      "L1.Worker.TimeoutLogFlushingL1Tests.TestTimeoutLogFlushingNotSet_DefaultsToDisabled"
      "L1.Worker.TimeoutLogFlushingL1Tests.TestTimeoutLogFlushingWithSingleStep_CompletesSuccessfully"
      "L1.Worker.VariableL1Tests.SetVariable_ReadVariable"
      "Listener.AgentAutoLogonTestL0.TestAutoLogonConfiguration"
      "Listener.AgentAutoLogonTestL0.TestAutoLogonConfigurationForDifferentUser"
      "Listener.AgentAutoLogonTestL0.TestAutoLogonConfigurationForDotAsDomainName"
      "Listener.AgentAutoLogonTestL0.TestAutoLogonRunOnce"
      "Listener.AgentAutoLogonTestL0.TestAutoLogonUnConfigure"
      "Listener.AgentAutoLogonTestL0.TestAutoLogonUnConfigureForDifferentUser"
      "Listener.Configuration.ArgumentValidatorTestsL0.WindowsLogonAccountValidator"
      "Listener.Configuration.ConfigurationManagerL0.CanEnsureConfigure"
      "Listener.Configuration.ConfigurationManagerL0.CanEnsureConfigureForDeploymentPool"
      "Listener.Configuration.ConfigurationManagerL0.CanEnsureEnvironmentVMResourceConfigureVSTSScenario"
      "Listener.Configuration.ConfigurationManagerL0.CanEnsureMachineGroupAgentConfigureOnPremScenario"
      "Listener.Configuration.ConfigurationManagerL0.CanEnsureMachineGroupAgentConfigureVSTSScenario"
      "Listener.Configuration.ConfigurationManagerL0.CanEnsureMachineGroupAgentConfigureVSTSScenarioWithTags"
      "Listener.PagingLoggerL0.CalculateLineNumbers"
      "Listener.PagingLoggerL0.CalculateLineNumbersWithGroupTag"
      "Listener.PagingLoggerL0.CalculateLineNumbersWithUpperCaseGroupTag"
      "Listener.PagingLoggerL0.CalculateLineNumbersWithoutCloseGroupTag"
      "Listener.PagingLoggerL0.CalculateLineNumbersWithoutOpenGroupTag"
      "Listener.PagingLoggerL0.ShipEmptyLog"
      "Listener.PagingLoggerL0.WriteAndShipLog"
      "Util.IOUtilL0.DeleteDirectory_DeleteTargetFileWithASymlink"
      "Util.IOUtilL0.DeleteDirectory_DeletesDirectoryReparsePointChain"
      "Util.IOUtilL0.DeleteDirectory_DeletesDirectoryReparsePointsBeforeDirectories"
      "Util.IOUtilL0.DeleteDirectory_DeletesWithRetry_CancellationRequested"
      "Util.IOUtilL0.DeleteDirectory_DeletesWithRetry_IOException"
      "Util.IOUtilL0.DeleteDirectory_DoesNotFollowDirectoryReparsePoint"
      "Util.IOUtilL0.DeleteDirectory_DoesNotFollowNestLevel1DirectoryReparsePoint"
      "Util.IOUtilL0.DeleteDirectory_DoesNotFollowNestLevel2DirectoryReparsePoint"
      "Util.IOUtilL0.DeleteFile_DeletesWithRetry_CancellationRequested"
      "Util.IOUtilL0.DeleteFile_DeletesWithRetry_IOException"
      "Util.IOUtilL0.GetRelativePathWindows"
      "Util.IOUtilL0.ResolvePathWindows"
      "Worker.Build.TrackingManagerL0.MarksTrackingConfigForGarbageCollection_Legacy"
      "Worker.GitManagerL0.DownloadAsync"
      "Worker.JobExtensionL0.JobExtensioBuildStepsList"
      "Worker.JobExtensionL0.JobExtensioBuildStepsListMSI"
      "Worker.JobExtensionL0.JobExtensionManagementScriptStep"
      "Worker.JobExtensionL0.JobExtensionManagementScriptStepMSI"
      "Worker.JobRunnerL0.ServerOMDirectoryVariableSetCorrectlyOnWindows"
      "Worker.TfManagerL0.DownloadAsync_Retries"
      "Worker.TfManagerL0.DownloadTfLegacyToolsAsync"
    ]
    ++ [
      "Test.L0.Listener.Configuration.NativeWindowsServiceHelperL0.EnsureGetDefaultAdminServiceAccountShouldReturnLocalSystemAccount"
      "Test.L0.Listener.Configuration.NativeWindowsServiceHelperL0.EnsureGetDefaultServiceAccountShouldReturnNetworkServiceAccount"
      "Test.L0.Worker.Handlers.ProcessHandlerL0.ProcessHandlerV2_BasicExecution"
      "Test.L0.Worker.Handlers.ProcessHandlerL0.ProcessHandlerV2_FileExecution"
      "Test.L0.Worker.Handlers.ProcessHandlerL0.ProcessHandlerV2_Validation_passes"
    ];

  installCheckPhase = ''
    runHook preInstallCheck

    export AGENT_ROOT="$TMPDIR"

    $out/bin/config.sh --help >/dev/null
    $out/bin/Agent.Listener --help >/dev/null

    agentVersion=$($out/bin/Agent.Listener --version)
    if [[ "$agentVersion" != "${finalAttrs.version}" ]]; then
      printf 'Unexpected version %s' "$agentVersion"
      exit 1
    fi

    commit=$($out/bin/Agent.Listener --commit)
    if [[ "$commit" != "$(git rev-parse HEAD)" ]]; then
      printf 'Unexpected commit %s' "$commit"
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Self-hosted agent for Azure Pipelines";
    longDescription = ''
      The Azure Pipelines Agent is a self-hosted agent that you can use to run
      jobs from Azure Pipelines. It connects to Azure DevOps Services or
      Azure DevOps Server to receive and execute build and deployment jobs.
    '';
    homepage = "https://github.com/Microsoft/azure-pipelines-agent";
    changelog = "https://github.com/microsoft/azure-pipelines-agent/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with lib.maintainers; [
      rudesome
    ];
    platforms = platforms.linux;
    mainProgram = "azure-pipelines-agent";
  };
})
