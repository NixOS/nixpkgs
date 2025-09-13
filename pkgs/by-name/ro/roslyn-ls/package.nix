{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  stdenvNoCC,
  testers,
  roslyn-ls,
  jq,
  writeText,
  runCommand,
  expect,
}:
let
  pname = "roslyn-ls";
  dotnet-sdk =
    with dotnetCorePackages;
    sdk_10_0
    // {
      inherit
        (combinePackages [
          sdk_9_0
          sdk_8_0
        ])
        packages
        targetPackages
        ;
    };
  # need sdk on runtime as well
  dotnet-runtime = dotnetCorePackages.sdk_10_0;
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.targetPlatform.system;

  project = "Microsoft.CodeAnalysis.LanguageServer";

  targets = writeText "versions.targets" ''
    <Project>
      <ItemGroup>
        <KnownFrameworkReference Update="@(KnownFrameworkReference)">
          <LatestRuntimeFrameworkVersion Condition="'%(TargetFramework)' == 'net8.0'">${dotnetCorePackages.sdk_8_0.runtime.version}</LatestRuntimeFrameworkVersion>
          <LatestRuntimeFrameworkVersion Condition="'%(TargetFramework)' == 'net9.0'">${dotnetCorePackages.sdk_9_0.runtime.version}</LatestRuntimeFrameworkVersion>
          <TargetingPackVersion Condition="'%(TargetFramework)' == 'net8.0'">${dotnetCorePackages.sdk_8_0.runtime.version}</TargetingPackVersion>
          <TargetingPackVersion Condition="'%(TargetFramework)' == 'net9.0'">${dotnetCorePackages.sdk_9_0.runtime.version}</TargetingPackVersion>
        </KnownFrameworkReference>
        <KnownAppHostPack Update="@(KnownAppHostPack)">
          <AppHostPackVersion Condition="'%(TargetFramework)' == 'net8.0'">${dotnetCorePackages.sdk_8_0.runtime.version}</AppHostPackVersion>
          <AppHostPackVersion Condition="'%(TargetFramework)' == 'net9.0'">${dotnetCorePackages.sdk_9_0.runtime.version}</AppHostPackVersion>
        </KnownAppHostPack>
      </ItemGroup>
    </Project>
  '';

in
buildDotnetModule (finalAttrs: rec {
  inherit pname dotnet-sdk dotnet-runtime;

  vsVersion = "2.90.51-prerelease";
  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "VSCode-CSharp-${vsVersion}";
    hash = "sha256-l2/EIvN/GFIyCZRNBnS7bAzkYB1wZbD1DxD1EW040X4=";
  };

  # versioned independently from vscode-csharp
  # "roslyn" in here:
  # https://github.com/dotnet/vscode-csharp/blob/main/package.json
  version = "5.0.0-2.25424.1";
  projectFile = "src/LanguageServer/${project}/${project}.csproj";
  useDotnetFromEnv = true;
  nugetDeps = ./deps.json;

  nativeBuildInputs = [ jq ];

  patches = [
    # until upstream updates net6.0 here:
    # https://github.com/dotnet/roslyn/blob/6cc106c0eaa9b0ae070dba3138a23aeab9b50c13/eng/targets/TargetFrameworks.props#L20
    ./force-sdk_8_0.patch
    # until made configurable/and or different location
    # https://github.com/dotnet/roslyn/issues/76892
    ./cachedirectory.patch
  ];

  postPatch = ''
    # Upstream uses rollForward = latestPatch, which pins to an *exact* .NET SDK version.
    jq '.sdk.rollForward = "latestMinor"' < global.json > global.json.tmp
    mv global.json.tmp global.json

    substituteInPlace Directory.Build.targets \
      --replace-fail '</Project>' '<Import Project="${targets}" /></Project>'
  '';

  dotnetFlags = [
    "-p:TargetRid=${rid}"
    # this removes the Microsoft.WindowsDesktop.App.Ref dependency
    "-p:EnableWindowsTargeting=false"
    # this is needed for the KnownAppHostPack changes to work
    "-p:EnableAppHostPackDownload=true"
  ];

  # two problems solved here:
  # 1. --no-build removed -> BuildHost project within roslyn is running Build target during publish
  # 2. missing crossgen2 7.* in local nuget directory when PublishReadyToRun=true
  # the latter should be fixable here but unsure how
  installPhase = ''
    runHook preInstall

    env dotnet publish $dotnetProjectFiles \
        -p:ContinuousIntegrationBuild=true \
        -p:Deterministic=true \
        -p:InformationalVersion=$version \
        -p:UseAppHost=true \
        -p:PublishTrimmed=false \
        -p:PublishReadyToRun=false \
        --configuration Release \
        --no-self-contained \
        --output "$out/lib/$pname" \
        --no-restore \
        --runtime ${rid} \
        ''${dotnetInstallFlags[@]}  \
        ''${dotnetFlags[@]}

    runHook postInstall
  '';

  passthru = {
    tests =
      let
        with-sdk =
          sdk:
          runCommand "with-${if sdk ? version then sdk.version else "no"}-sdk"
            {
              nativeBuildInputs = [
                finalAttrs.finalPackage
                sdk
                expect
              ];
              meta.timeout = 60;
            }
            ''
              HOME=$TMPDIR
              expect <<"EOF"
                spawn ${meta.mainProgram} --stdio --logLevel Information --extensionLogDirectory log
                expect_before timeout {
                  send_error "timeout!\n"
                  exit 1
                }
                expect "Language server initialized"
                send \x04
                expect eof
                catch wait result
                exit [lindex $result 3]
              EOF
              touch $out
            '';
      in
      {
        # Make sure we can run with any supported SDK version, as well as without
        with-net9-sdk = with-sdk dotnetCorePackages.sdk_9_0;
        with-net10-sdk = with-sdk dotnetCorePackages.sdk_10_0;
        no-sdk = with-sdk null;
        version = testers.testVersion { package = finalAttrs.finalPackage; };
      };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/dotnet/vscode-csharp";
    description = "Language server behind C# Dev Kit for Visual Studio Code";
    changelog = "https://github.com/dotnet/vscode-csharp/releases/tag/v${vsVersion}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "Microsoft.CodeAnalysis.LanguageServer";
  };
})
