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
buildDotnetModule rec {
  pname = "azure-pipelines-agent";
  version = "4.259.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "azure-pipelines-agent";
    tag = "v${version}";
    hash = "sha256-7wd7fYI/cCfAz3usUzH6pyJ5mVAPpo6LNlbXOYcZ47k=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = isNull glibcLocales;
  LOCALE_ARCHIVE = lib.optionalString (
    !DOTNET_SYSTEM_GLOBALIZATION_INVARIANT
  ) "${glibcLocales}/lib/locale/locale-archive";

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
      -p:AgentVersion="${version}" \
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

  preCheck = ''
    mkdir -p _layout/externals
    ln -s ${nodejs_20} _layout/externals/node20_1
  '';

  postInstall =
    ''
      mkdir -p $out/bin
      mkdir -p $out/lib/${pname}/en-US

      install -m755 src/Misc/layoutbin/AgentService.js          $out/lib/${pname}
      install -m755 src/Misc/layoutbin/en-US/strings.json       $out/lib/${pname}/en-US
      install -m755 src/Misc/layoutbin/runsvc.sh                $out/lib/${pname}
      install -m755 src/Misc/layoutroot/config.sh               $out/lib/${pname}
      install -m755 src/Misc/layoutroot/env.sh                  $out/lib/${pname}
      install -m755 src/Misc/layoutroot/license.html            $out/lib/${pname}
      install -m755 src/Misc/layoutroot/reauth.sh               $out/lib/${pname}
      install -m755 src/Misc/layoutroot/run.sh                  $out/lib/${pname}

      # env.sh is patched to not require any wrapping
      ln -sr "$out/lib/${pname}/env.sh" "$out/bin/"

      substituteInPlace $out/lib/${pname}/config.sh \
          --replace-fail './bin/Agent.Listener' "$out/bin/Agent.Listener"

      substituteInPlace $out/lib/${pname}/run.sh --replace-fail '"$DIR"/bin/' '"$DIR"/'

      substituteInPlace $out/lib/${pname}/config.sh \
        --replace-fail 'command -v ldd' 'command -v ${glibc.bin}/bin/ldd' \
        --replace 'ldd ./bin' '${lib.getBin glibc}/bin/ldd ${dotnet-runtime}/share/dotnet/shared/Microsoft.NETCore.App/${dotnet-runtime.version}/' \
        --replace '/sbin/ldconfig' '${glibc.bin}/bin/ldconfig'

      # Make paths absolute
      substituteInPlace $out/lib/${pname}/runsvc.sh \
        --replace './externals' "$out/lib/externals" \
        --replace './bin/AgentService.js' "$out/lib/${pname}/AgentService.js"

      # The upstream package includes Node and expects it at the path
      # externals/node$version. As opposed to the official releases, we don't
      # link the Alpine Node flavors.
      mkdir -p $out/lib/externals
      ln -s ${nodejs_20} $out/lib/externals/node20_1
    ''
    + ''
      # Use makeWrapperArgs to point to the launcher
      makeWrapperArgs+=(
        --run 'export AGENT_ROOT="''${AGENT_ROOT:-"$HOME/.azure-agent"}"'
        --run 'mkdir -p "$AGENT_ROOT"'
        --chdir "$out"
      )
    '';

  dotnetInstallFlags = [
    "-f"
    "net8.0"
  ];

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
      "L1.Worker.CoreL1Tests.Test_Base_Node10"
      "L1.Worker.SigningL1Tests.SignatureVerification_Disabled"
      "L1.Worker.SigningL1Tests.SignatureVerification_MultipleFingerprints"
      "L1.Worker.SigningL1Tests.SignatureVerification_PassesWhenAllTasksAreSigned"
      "L1.Worker.SigningL1Tests.SignatureVerification_Warning"
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
      "ProcessInvokerL0.OomScoreAdjIsInherited"
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
      "Worker.JobExtensionL0.JobExtensionManagementScriptStep"
      "Worker.JobExtensionL0.JobExtensionManagementScriptStepMSI"
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

    version=$($out/bin/Agent.Listener --version)
    if [[ "$version" != "${version}" ]]; then
      printf 'Unexpected version %s' "$version"
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
    description = "Azure Pipelines Agent - Self-hosted agent to run Azure Pipeline jobs";
    longDescription = ''
      The Azure Pipelines Agent is a self-hosted agent that you can use to run
      jobs from Azure Pipelines. It connects to Azure DevOps Services or
      Azure DevOps Server to receive and execute build and deployment jobs.
    '';
    homepage = "https://github.com/Microsoft/azure-pipelines-agent";
    license = licenses.mit;
    maintainers = with lib.maintainers; [
      rudesome
    ];
    platforms = platforms.linux;
    mainProgram = "azure-pipelines-agent";
  };
}
