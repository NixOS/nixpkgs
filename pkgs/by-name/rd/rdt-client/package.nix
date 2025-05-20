{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  buildNpmPackage,
  nix-update-script,
  nixosTests,
}:

let
  pname = "rdt-client";
  version = "2.0.112";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

  src = fetchFromGitHub {
    owner = "rogerfar";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-UQP7gi5gspMQvpnfGlnlVlUR0fCT6KHFpmXcS/s5TgM=";
  };

  frontend = buildNpmPackage {
    inherit version;
    pname = "${pname}-frontend";
    src = "${src}/client";
    npmDepsHash = "sha256-QChMUzIj2m6E2U0CRmuyKAvP/gE5Wp8SqHxFFFz9abQ=";

    # Need to override the output path defined in client/angular.json
    npmBuildFlags = "-- --output-path=${placeholder "out"}/dist";

    passthru.updatescript = nix-update-script { };
  };

in
buildDotnetModule {
  inherit pname version;
  src = "${src}/server";
  projectFile = "RdtClient.Web/RdtClient.Web.csproj";
  nugetDeps = ./nuget-deps.json;

  dotnet-sdk = dotnet-sdk;
  dotnet-runtime = dotnet-runtime;
  dotnetBuildFlags = [ "--no-self-contained" "-p:Version=${version}" "-p:AssemblyVersion=${version}" ];

  executables = [ "RdtClient.Web" ];

  # This patch allows us to override the appsettings.json with environment variables or command line args
  patches = [ ./allow-easier-config.diff ];

  postInstall = ''
    mkdir -p $out/lib/rdt-client/wwwroot
    cp -r ${frontend}/dist/browser/* $out/lib/rdt-client/wwwroot/
  '';

  makeWrapperArgs = [ "--set DOTNET_CONTENTROOT ${placeholder "out"}/lib/rdt-client" ];

  passthru.tests = {
    smoke-test = nixosTests.rdt-client;
  };

  meta = {
    description = "Real-Debrid Client Proxy";
    homepage = "https://github.com/rogerfar/rdt-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmilligan
    ];
    mainProgram = "RdtClient.Web";
    platforms = dotnet-runtime.meta.platforms;
  };
}
