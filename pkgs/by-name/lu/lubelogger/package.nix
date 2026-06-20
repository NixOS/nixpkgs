{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "lubelogger";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "hargata";
    repo = "lubelog";
    rev = "v${version}";
    hash = "sha256-goj9xGHZaX6XMYqlvOpabTXTT3/GcuvcRjr6GwVTFA4=";
  };

  projectFile = "CarCareTracker.sln";
  nugetDeps = ./deps.json; # File generated with `nix-build -A lubelogger.passthru.fetch-deps`.

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  makeWrapperArgs = [
    "--set DOTNET_WEBROOT ${placeholder "out"}/lib/lubelogger/wwwroot"
  ];

  executables = [ "CarCareTracker" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.

  meta = {
    description = "Vehicle service records and maintainence tracker";
    longDescription = ''
      A self-hosted, open-source, unconventionally-named vehicle maintenance records and fuel mileage tracker.
    '';
    homepage = "https://lubelogger.com";
    changelog = "https://github.com/hargata/lubelog/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lyndeno ];
    mainProgram = "CarCareTracker";
    platforms = lib.platforms.all;
  };
}
