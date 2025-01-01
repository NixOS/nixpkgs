{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  mono,
}:

buildDotnetModule rec {
  pname = "bicep";
  version = "0.30.23";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "bicep";
    rev = "v${version}";
    hash = "sha256-EQMSqEvBdOEnntv2glVp19LsjC4Zvh5U0zx0h3n8Okc=";
  };

  postPatch = ''
    substituteInPlace src/Directory.Build.props --replace-fail "<TreatWarningsAsErrors>true</TreatWarningsAsErrors>" ""
  '';

  projectFile = "src/Bicep.Cli/Bicep.Cli.csproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # mono is not available on aarch64-darwin

  nativeCheckInputs = [ mono ];

  testProjectFile = "src/Bicep.Cli.UnitTests/Bicep.Cli.UnitTests.csproj";

  passthru.updateScript = ./updater.sh;

  meta = {
    description = "Domain Specific Language (DSL) for deploying Azure resources declaratively";
    homepage = "https://github.com/Azure/bicep/";
    changelog = "https://github.com/Azure/bicep/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ] ++ lib.teams.stridtech.members;
    mainProgram = "bicep";
  };
}
