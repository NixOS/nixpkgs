{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "BinaryObjectScanner";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "SabreTools";
    repo = "BinaryObjectScanner";
    tag = version;
    hash = "sha256-FiSBJO4ic/KjokUEP0uB1WNfFRcOWH/x0y9yJMKnl4Q=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  dotnetFlags = [ "-p:TargetFramework=net9.0" ];
  nugetDeps = ./deps.json;

  projectFile = [
    "ProtectionScan/ProtectionScan.csproj"
    "ExtractionTool/ExtractionTool.csproj"
  ];
  executables = [
    "ProtectionScan"
    "ExtractionTool"
  ];

  meta = {
    homepage = "https://github.com/SabreTools/BinaryObjectScanner";
    description = "C# protection, packer, and archive scanning library. Provides ProtectionScan and ExtractionTool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    mainProgram = "ProtectionScan";
  };
}
