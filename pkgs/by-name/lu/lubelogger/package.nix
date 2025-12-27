{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "lubelogger";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "hargata";
    repo = "lubelog";
    rev = "v${version}";
    hash = "sha256-xoq1EgwA4MScuyVN4djqWPjlRXouMR3JnZviOIaDNUU=";
  };

  projectFile = "CarCareTracker.sln";
  nugetDeps = ./deps.json; # File generated with `nix-build -A lubelogger.passthru.fetch-deps`.

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  makeWrapperArgs = [
    "--set DOTNET_WEBROOT ${placeholder "out"}/lib/lubelogger/wwwroot"
  ];

  executables = [ "CarCareTracker" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.

  meta = {
    description = "Vehicle service records and maintainence tracker";
    longDescription = ''
      A self-hosted, open-source, unconventionally-named vehicle maintenance records and fuel mileage tracker.

      LubeLogger by Hargata Softworks is licensed under the MIT License for individual and personal use. Commercial users and/or corporate entities are required to maintain an active subscription in order to continue using LubeLogger.
    '';
    homepage = "https://lubelogger.com";
    changelog = "https://github.com/hargata/lubelog/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lyndeno ];
    mainProgram = "CarCareTracker";
    platforms = lib.platforms.all;
  };
}
