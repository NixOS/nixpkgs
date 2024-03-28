{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
}:
buildDotnetModule rec {
  pname = "dotnet-outdated";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "dotnet-outdated";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U5qCM+Um8bRafrDpbI5TnSN1nQ8mQpZ5W8Jao2hdAPw=";
  };

  dotnet-sdk = dotnetCorePackages.dotnet_8.sdk;
  dotnet-runtime = dotnetCorePackages.dotnet_8.runtime;
  useDotnetFromEnv = true;

  nugetDeps = ./deps.nix;

  projectFile = "src/DotNetOutdated/DotNetOutdated.csproj";
  executables = "dotnet-outdated";

  dotnetInstallFlags = [ "--framework" "net8.0" ];

  meta = with lib; {
    description = "A .NET Core global tool to display and update outdated NuGet packages in a project";
    homepage = "https://github.com/dotnet-outdated/dotnet-outdated";
    sourceProvenance = with sourceTypes; [
      fromSource
      # deps
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.mit;
    maintainers = with maintainers; [ emilioziniades ];
    mainProgram = "dotnet-outdated";
  };
}
