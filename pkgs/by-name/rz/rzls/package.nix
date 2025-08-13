{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  jq,
}:
let
  pname = "rzls";
  dotnet-sdk =
    with dotnetCorePackages;
    sdk_9_0
    // {
      inherit (sdk_8_0)
        packages
        targetPackages
        ;
    };
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

in
buildDotnetModule {
  inherit pname dotnet-sdk dotnet-runtime;

  src = fetchFromGitHub {
    owner = "dotnet";
    repo = "razor";
    rev = "ce522dd7670dc8e5885b8d078ff5be2877ee33ed";
    hash = "sha256-FabK93NBoabQPuUr+yaXOxd2acrN3OMqeeCIT6nvAtw=";
  };

  version = "10.0.0-preview.25403.1";
  projectFile = "src/Razor/src/rzls/rzls.csproj";
  useDotnetFromEnv = true;
  nugetDeps = ./deps.json;

  nativeBuildInputs = [ jq ];

  postPatch = ''
    # Upstream uses rollForward = latestPatch, which pins to an *exact* .NET SDK version.
    jq '.sdk.rollForward = "latestMinor"' < global.json > global.json.tmp
    mv global.json.tmp global.json
  '';

  dotnetFlags = [
    # this removes the Microsoft.WindowsDesktop.App.Ref dependency
    "-p:EnableWindowsTargeting=false"
    "-p:PublishReadyToRun=false"
  ];

  dotnetInstallFlags = [
    "-p:InformationalVersion=$version"
  ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/dotnet/razor";
    description = "Razor language server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bretek
      tris203
    ];
    mainProgram = "rzls";
  };
}
