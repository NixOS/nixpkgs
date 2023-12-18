{ lib
, buildDotnetModule
, dotnetCorePackages
, stdenv
, libunwind
, libuuid
, icu
, openssl
, zlib
, curl
, dotnet-sdk_6
, fetchFromGitHub
}:
buildDotnetModule rec {
  inherit dotnet-sdk_6;
  version = "1.0.9";
  src = fetchFromGitHub {
      owner = "microsoft";
      repo = "artifacts-credprovider";
      rev = "v${version}";
      sha256 = "sha256-ZlTwxesEP0N2yVCuroaTcq+pRylU4fF+RojbhMzTGyw=";
  };
  pname = "azure-artifacts-credprovider";
  projectFile =  "CredentialProvider.Microsoft/CredentialProvider.Microsoft.csproj";
  testProjectFile = "CredentialProvider.Microsoft.Tests/CredentialProvider.Microsoft.Tests.csproj";
  nugetDeps = ./deps.nix;
  passthru.updateScript = ./update.sh;
  dotnetInstallFlags = [
    "-f:net6.0"
  ];
  meta = with lib; {
    homepage = "https://github.com/microsoft/artifacts-credprovider";
    description = "Azure Artifacts Credential Provider";
    license = licenses.mit;
    maintainers = with maintainers; [ anpin ];
    mainProgram = "CredentialProvider.Microsoft";
    platforms = [ "x86_64-linux" ];
  };
}
