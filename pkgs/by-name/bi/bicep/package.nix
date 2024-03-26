{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, mono
}:

buildDotnetModule rec {
  pname = "bicep";
  version = "0.26.54";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "bicep";
    rev = "v${version}";
    hash = "sha256-Obu9I2FzuYBD466DE9VZnjTHSRX+qeKqTiIJ2433DQc=";
  };

  projectFile = "src/Bicep.Cli/Bicep.Cli.csproj";

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  doCheck = !(stdenv.isDarwin && stdenv.isAarch64); # mono is not available on aarch64-darwin

  nativeCheckInputs = [ mono ];

  testProjectFile = "src/Bicep.Cli.UnitTests/Bicep.Cli.UnitTests.csproj";

  passthru.updateScript = ./updater.sh;

  meta = {
    broken = stdenv.isDarwin;
    description = "Domain Specific Language (DSL) for deploying Azure resources declaratively";
    homepage = "https://github.com/Azure/bicep/";
    changelog = "https://github.com/Azure/bicep/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
