{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  protobuf,
  grpc,
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

  # Grpc.Tools only ships x86_64 protoc and grpc_csharp_plugin for macOS,
  # which fail with "Bad CPU type in executable" without Rosetta.
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    PROTOBUF_PROTOC = lib.getExe' protobuf "protoc";
    GRPC_PROTOC_PLUGIN = lib.getExe' grpc "grpc_csharp_plugin";
  };

  doCheck = true;

  # On macOS, .NET takes the culture from the system region and ignores
  # LANG/LC_ALL, so DeploymentRendererTests fail with e.g. "0,3s" instead of
  # "0.3s". Only set this for tests: during the build it breaks the
  # GeneratedRegex source generator (SYSLIB1042).
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
  '';

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
