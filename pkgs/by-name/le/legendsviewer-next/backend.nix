{
  version,
  src,
  patches,
  frontend,

  dotnetCorePackages,

  buildDotnetModule,
  nix-update-script,
  writeShellScriptBin,
}:
let
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
in
buildDotnetModule rec {
  pname = "legends-viewer-backend";
  inherit version src patches;

  inherit dotnet-sdk dotnet-runtime;
  nugetDeps = ./deps.json;
  projectFile = "./LegendsViewer.Backend/LegendsViewer.Backend.csproj";
  testProjectFile = "./LegendsViewer.Backend.Tests/LegendsViewer.Backend.Tests.csproj";
  executables = [ "LegendsViewer" ];

  nativeBuildInputs = [
    # This fixes a build failure, we don't care about the frontend node build
    (writeShellScriptBin "npm" "")
  ];

  installPhase = ''
    runHook preInstall

    lib=$out/lib/${pname}

    mkdir -p $lib

    cp ./LegendsViewer.Backend/bin/Release/*/*/* $lib
    ln -s ${frontend} $lib/${frontend.pname}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
}
