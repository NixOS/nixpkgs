{ lib
, buildDotnetModule
, dotnetCorePackages
, stdenvNoCC
, testers
, roslyn-ls
}:
let
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  # need sdk on runtime as well
  dotnet-runtime = dotnet-sdk;

  project = "Microsoft.CodeAnalysis.LanguageServer";
  projectLower = lib.toLower project;
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.targetPlatform.system;
in
buildDotnetModule rec {
  inherit dotnet-sdk dotnet-runtime;

  pname = "roslyn-ls";
  src = ./.;

  # see all versions below:
  # https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.linux-x64/versions
  version = "4.12.0-1.24378.2";
  projectFile = "./ServerDownload.csproj";
  nugetDeps = ./deps.nix;

  postPatch = ''
    substituteInPlace $projectFile \
      --replace-fail '$(PackageName)' '${projectLower}' \
      --replace-fail '$(PackageVersion)' '${version}'
  '';

  buildPhase = ''
    mkdir -p $out
    mv ~/.nuget/packages/${projectLower}.${rid}/${version}/content/LanguageServer/${rid} $out/lib
  '';

  installPhase = ''
    makeWrapper $out/lib/${project} $out/bin/${project} \
      --set DOTNET_ROOT ${dotnet-runtime}
  '';

  passthru = {
    tests.version = testers.testVersion { package = roslyn-ls; };
  };

  meta = {
    homepage = "https://github.com/dotnet/vscode-csharp";
    description = "Language server behind C# Dev Kit for Visual Studio Code";
    changelog = "https://github.com/dotnet/vscode-csharp/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "Microsoft.CodeAnalysis.LanguageServer";
  };
}
