{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule
}:

buildDotnetModule rec {
  pname = "cfipv6";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "BorgGames";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fTjOW0TYjBplHqkrrvb9UIsHkRfAJt9d0GgBHI/VYhM=";
  };

  projectFile = "cfipv6.csproj";
  executables = [ pname ];
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./nuget-deps.nix;

  meta = with lib; {
    homepage = "https://github.com/BorgGames/cfipv6";
    description = "DynDNS service for IPv6 and CloudFlare";
    mainProgram = "cfipv6";
    license = licenses.mit;
  };
}
