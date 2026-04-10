{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "bicep";
  version = "0.47.16";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "bicep";
    rev = "v${version}";
    hash = "sha256-V8YpTc7GqP42a+Z/cKW/R4WrwbCyPY0+kYuotA4ec4E=";
  };

  postPatch = ''
    substituteInPlace src/Directory.Build.props --replace-fail "<TreatWarningsAsErrors>true</TreatWarningsAsErrors>" ""
  '';

  projectFile = [
    "src/Bicep.Cli/Bicep.Cli.csproj"
    "src/Bicep.LangServer/Bicep.LangServer.csproj"
  ];

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0_4xx-bin;

  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  # Compression in single-file bundles requires self-contained builds.
  dotnetInstallFlags = [ "-p:EnableCompressionInSingleFile=false" ];

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
    mainProgram = "bicep";
  };
}
