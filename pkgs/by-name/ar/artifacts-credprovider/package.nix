{
  lib,
  fetchurl,
  buildDotnetPackage,
}:
buildDotnetPackage rec {
  pname = "artifacts-credprovider";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/microsoft/artifacts-credprovider/releases/download/v${version}/Microsoft.Net8.NuGet.CredentialProvider.tar.gz";
    hash = "sha256-WEssfdOKMjJ3WD/egD4wA69k+JdB9O/ZWM8RstRJGkA=";
  };

  dontBuild = true;
  outputFiles = [ "netcore/*" ];

  meta = {
    description = "Automates the acquisition of credentials needed to restore NuGet packages as part of your .NET development workflow";
    changelog = "https://github.com/microsoft/artifacts-credprovider/releases/tag/v${version}";
    homepage = "https://github.com/microsoft/artifacts-credprovider";
    license = lib.licenses.mit;
    longDescription = ''
      The Azure Artifacts Credential Provider automates the acquisition of credentials needed to restore NuGet packages as part of your .NET development workflow.
      It integrates with MSBuild, dotnet, and NuGet(.exe) and works on Windows, Mac, and Linux.
      Any time you want to use packages from an Azure Artifacts feed, the Credential Provider will automatically acquire and securely store a token on behalf of the NuGet client you're using
    '';
    maintainers = with lib.maintainers; [ khaneliman ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = lib.platforms.all;
  };
}
