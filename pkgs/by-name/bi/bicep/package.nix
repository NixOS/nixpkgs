{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  mono,
  jq,
}:

buildDotnetModule rec {
  pname = "bicep";
  version = "0.36.177";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "bicep";
    rev = "v${version}";
    hash = "sha256-ah8g1mU2etQ/zoXcGbS+xRkTb4DjPmofe2ubZSNRhNU=";
  };

  patches = [
    ./0001-Revert-Bump-Grpc.Tools-from-2.68.1-to-2.69.0-16097.patch
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

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # mono is not available on aarch64-darwin

  nativeCheckInputs = [ mono ];

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
