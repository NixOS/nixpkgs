{ lib, fetchFromGitHub, buildDotnetModule, dotnetCorePackages, stdenvNoCC, testers, roslyn-ls, jq }:
let
  pname = "roslyn-ls";
  # see https://github.com/dotnet/roslyn/blob/main/eng/targets/TargetFrameworks.props
  dotnet-sdk = with dotnetCorePackages; combinePackages [ sdk_6_0 sdk_7_0 sdk_8_0 ];
  # need sdk on runtime as well
  dotnet-runtime = dotnetCorePackages.sdk_8_0;

  project = "Microsoft.CodeAnalysis.LanguageServer";
in
buildDotnetModule rec {
  inherit pname dotnet-sdk dotnet-runtime;

  vsVersion = "2.22.2";
  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "VSCode-CSharp-${vsVersion}";
    hash = "sha256-j7PXgYjISlPBbhUEEIxkDlOx7TMYPHtC3KH2DViWxJ8=";
  };

  # versioned independently from vscode-csharp
  # "roslyn" in here:
  # https://github.com/dotnet/vscode-csharp/blob/main/package.json
  version = "4.10.0-2.24124.2";
  projectFile = "src/Features/LanguageServer/${project}/${project}.csproj";
  useDotnetFromEnv = true;
  nugetDeps = ./deps.nix;

  nativeBuildInputs = [ jq ];

  postPatch = ''
    # Upstream uses rollForward = latestPatch, which pins to an *exact* .NET SDK version.
    jq '.sdk.rollForward = "latestMinor"' < global.json > global.json.tmp
    mv global.json.tmp global.json

    substituteInPlace $projectFile \
      --replace-fail \
        '>win-x64;win-x86;win-arm64;linux-x64;linux-arm64;linux-musl-x64;linux-musl-arm64;osx-x64;osx-arm64</RuntimeIdentifiers>' \
        '>linux-x64;linux-arm64;osx-x64;osx-arm64</RuntimeIdentifiers>'
  '';

  # two problems solved here:
  # 1. --no-build removed -> BuildHost project within roslyn is running Build target during publish
  # 2. missing crossgen2 7.* in local nuget directory when PublishReadyToRun=true
  # the latter should be fixable here but unsure how
  installPhase =
    let
      rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.targetPlatform.system;
    in
    ''
      runHook preInstall

      env dotnet publish $projectFile \
          -p:ContinuousIntegrationBuild=true \
          -p:Deterministic=true \
          -p:InformationalVersion=$version \
          -p:UseAppHost=true \
          -p:PublishTrimmed=false \
          -p:PublishReadyToRun=false \
          --configuration Release \
          --no-self-contained \
          --output "$out/lib/$pname" \
          --runtime ${rid}

      runHook postInstall
    '';

  passthru = {
    tests.version = testers.testVersion { package = roslyn-ls; };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/dotnet/vscode-csharp";
    description = "The language server behind C# Dev Kit for Visual Studio Code";
    changelog = "https://github.com/dotnet/vscode-csharp/releases/tag/v${vsVersion}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "Microsoft.CodeAnalysis.LanguageServer";
  };
}
