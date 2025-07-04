{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule rec {
  pname = "dotnet-outdated";
  version = "4.6.4";

  src = fetchFromGitHub {
    owner = "dotnet-outdated";
    repo = "dotnet-outdated";
    rev = "v${version}";
    hash = "sha256-Ah5VOCIkSRkeDWk/KYHIc/OELo0T/HuJl0LEUiumlu0=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  useDotnetFromEnv = true;

  nugetDeps = ./deps.json;

  projectFile = "src/DotNetOutdated/DotNetOutdated.csproj";
  executables = "dotnet-outdated";

  dotnetFlags = [ "-p:TargetFrameworks=net8.0" ];
  dotnetInstallFlags = [
    "--framework"
    "net8.0"
  ];

  meta = with lib; {
    description = ".NET Core global tool to display and update outdated NuGet packages in a project";
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
