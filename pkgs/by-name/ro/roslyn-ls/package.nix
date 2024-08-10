{ lib, fetchFromGitHub, buildDotnetModule, dotnetCorePackages, stdenvNoCC, testers, roslyn-ls, jq }:
let
  pname = "roslyn-ls";
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  # need sdk on runtime as well
  dotnet-runtime = dotnet-sdk;

  project = "Microsoft.CodeAnalysis.LanguageServer";
in
buildDotnetModule rec {
  inherit pname dotnet-sdk dotnet-runtime;

  vsVersion = "2.39.29";
  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "roslyn";
    rev = "VSCode-CSharp-${vsVersion}";
    hash = "sha256-E0gha6jZnXyRVH5XUuXxa7H9+2lfD9XTlQcNSiQycHA=";
  };

  # versioned independently from vscode-csharp
  # "roslyn" in here:
  # https://github.com/dotnet/vscode-csharp/blob/main/package.json
  version = "4.12.0-1.24359.11";
  projectFile = "src/LanguageServer/${project}/${project}.csproj";
  useDotnetFromEnv = true;
  nugetDeps = ./deps.nix;

  nativeBuildInputs = [ jq ];

  postPatch = ''
    # Upstream uses rollForward = latestPatch, which pins to an *exact* .NET SDK version.
    jq '.sdk.rollForward = "latestMinor"' < global.json > global.json.tmp
    mv global.json.tmp global.json

    substituteInPlace $projectFile \
      --replace-fail \
        '>win-x64;win-arm64;linux-x64;linux-arm64;linux-musl-x64;linux-musl-arm64;osx-x64;osx-arm64</RuntimeIdentifiers>' \
        '>linux-x64;linux-arm64;osx-x64;osx-arm64</RuntimeIdentifiers>'
  '';

  dotnetFlags = [
    # this removes the Microsoft.WindowsDesktop.App.Ref dependency
    "-p:EnableWindowsTargeting=false"
    # see this comment: https://github.com/NixOS/nixpkgs/pull/318497#issuecomment-2256096471
    # we can remove below line after https://github.com/dotnet/roslyn/issues/73439 is fixed
    "-p:UsingToolMicrosoftNetCompilers=false"
  ];

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
