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
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "artifacts-credprovider";
    rev = "v${version}";
    sha256 = "sha256-MYOl+UfRExeZsozcPJynWbx5JpYL0dxTADycAt6Wm7o=";
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
    platforms = [ "x86_64-linux" ];
  };
}
