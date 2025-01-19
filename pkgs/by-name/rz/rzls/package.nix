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
    rev = "dd64bf78c16a7e8fa1900da060100e9338383dea";
    hash = "sha256-C5/Mc5HxxAVGLO6IPhyyBNLcjvjmF8sKg1KpIdN0/KQ=";
  };

  version = "9.0.0-preview.25052.3";
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
