{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  stdenvNoCC,
  testers,
  roslyn-ls,
  jq,
}:
let
  pname = "roslyn-ls";
  dotnet-sdk =
    with dotnetCorePackages;
    sdk_9_0
    // {
      inherit
        (combinePackages [
          sdk_9_0
          sdk_8_0
          # NOTE: we should be able to remove net6.0 after upstream removes from here:
          # https://github.com/dotnet/roslyn/blob/6cc106c0eaa9b0ae070dba3138a23aeab9b50c13/eng/targets/TargetFrameworks.props#L20
          sdk_6_0
        ])
        packages
        targetPackages
        ;
    };
  # need sdk on runtime as well
  dotnet-runtime = dotnetCorePackages.sdk_9_0;
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.targetPlatform.system;

  project = "Microsoft.CodeAnalysis.LanguageServer";
in
buildDotnetModule rec {
  inherit pname dotnet-sdk dotnet-runtime;

  vsVersion = "2.59.14";
  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "VSCode-CSharp-${vsVersion}";
    hash = "sha256-tzBIqXBtPGupBBvHTFO93w6f5qCgllWY420xtjf9o3g=";
  };

  # versioned independently from vscode-csharp
  # "roslyn" in here:
  # https://github.com/dotnet/vscode-csharp/blob/main/package.json
  version = "4.13.0-3.24577.4";
  projectFile = "src/LanguageServer/${project}/${project}.csproj";
  useDotnetFromEnv = true;
  nugetDeps = ./deps.json;

  nativeBuildInputs = [ jq ];

  postPatch = ''
    # Upstream uses rollForward = latestPatch, which pins to an *exact* .NET SDK version.
    jq '.sdk.rollForward = "latestMinor"' < global.json > global.json.tmp
    mv global.json.tmp global.json
  '';

  dotnetFlags = [
    "-p:TargetRid=${rid}"
    # this removes the Microsoft.WindowsDesktop.App.Ref dependency
    "-p:EnableWindowsTargeting=false"
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
    tests.version = testers.testVersion { package = roslyn-ls; };
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
}
