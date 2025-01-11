{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:
buildDotnetModule rec {
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "artifacts-credprovider";
    rev = "v${version}";
    sha256 = "sha256-JbcoDs4c/+uKIgVWZkuo4jqd1hlqe+H949jNfkDwZls=";
  };
  pname = "azure-artifacts-credprovider";
  projectFile = "CredentialProvider.Microsoft/CredentialProvider.Microsoft.csproj";
  testProjectFile = "CredentialProvider.Microsoft.Tests/CredentialProvider.Microsoft.Tests.csproj";
  nugetDeps = ./deps.json;
  passthru.updateScript = ./update.sh;
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
