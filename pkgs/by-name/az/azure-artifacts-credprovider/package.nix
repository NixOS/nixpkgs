{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
}:
buildDotnetModule rec {
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  version = "2.0.4";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "artifacts-credprovider";
    rev = "v${version}";
    sha256 = "sha256-NAQi/36/1vd8flBtcg/Vd0i9bg2r+qMju3fMC+5mgXs=";
  };
  pname = "azure-artifacts-credprovider";
  projectFile = "CredentialProvider.Microsoft/CredentialProvider.Microsoft.csproj";
  testProjectFile = "CredentialProvider.Microsoft.Tests/CredentialProvider.Microsoft.Tests.csproj";
  nugetDeps = ./deps.json;
  passthru.updateScript = nix-update-script { };
  patchPhase = ''
    sed -i 's|<TargetFrameworks>.*</TargetFrameworks>|<TargetFramework>net8.0</TargetFramework>|' Build.props
  '';
  meta = {
    homepage = "https://github.com/microsoft/artifacts-credprovider";
    description = "Azure Artifacts Credential Provider";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anpin ];
    mainProgram = "CredentialProvider.Microsoft";
    platforms = lib.platforms.unix;
  };
}
