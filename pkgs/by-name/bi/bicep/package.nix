{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  jq,
}:

buildDotnetModule rec {
  pname = "bicep";
  version = "0.39.26";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "bicep";
    rev = "v${version}";
    hash = "sha256-CfoC9/Qe2OdPNnAa7e0BFgbPEbVrDfl9u3hM6y8msGQ=";
  };

  patches = [
    ./0001-Pin-Grpc.Tools-To-2.68.1.patch
  ];

  postPatch = ''
    substituteInPlace src/Directory.Build.props --replace-fail "<TreatWarningsAsErrors>true</TreatWarningsAsErrors>" ""
    # Upstream uses rollForward = disable, which pins to an *exact* .NET SDK version.
    jq '.sdk.rollForward = "latestMinor"' < global.json > global.json.tmp
    mv global.json.tmp global.json
  '';

  projectFile = [
    "src/Bicep.Cli/Bicep.Cli.csproj"
    "src/Bicep.LangServer/Bicep.LangServer.csproj"
  ];

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0_4xx-bin;

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nativeBuildInputs = [ jq ];

  doCheck = true;

  dotnetTestFlags = "-p:UseAppHost=false";

  testProjectFile = "src/Bicep.Cli.UnitTests/Bicep.Cli.UnitTests.csproj";

  passthru.updateScript = ./updater.sh;

  meta = {
    description = "Domain Specific Language (DSL) for deploying Azure resources declaratively";
    homepage = "https://github.com/Azure/bicep/";
    changelog = "https://github.com/Azure/bicep/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    teams = [ lib.teams.stridtech ];
    mainProgram = "bicep";
  };
}
