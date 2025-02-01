{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "lubelogger";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "hargata";
    repo = "lubelog";
    rev = "v${version}";
    hash = "sha256-D++znvzK8hoHOrsLBQTGqkTS/E8Y6IdiZ5fidd2HZmw=";
  };

  projectFile = "CarCareTracker.sln";
  nugetDeps = ./deps.json; # File generated with `nix-build -A lubelogger.passthru.fetch-deps`.

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  makeWrapperArgs = [
    "--set DOTNET_WEBROOT ${placeholder "out"}/lib/lubelogger/wwwroot"
  ];

  executables = [ "CarCareTracker" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.

  meta = with lib; {
    description = "Vehicle service records and maintainence tracker";
    longDescription = ''
      A self-hosted, open-source, unconventionally-named vehicle maintenance records and fuel mileage tracker.

      LubeLogger by Hargata Softworks is licensed under the MIT License for individual and personal use. Commercial users and/or corporate entities are required to maintain an active subscription in order to continue using LubeLogger.
    '';
    homepage = "https://lubelogger.com";
    changelog = "https://github.com/hargata/lubelog/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lyndeno ];
    mainProgram = "CarCareTracker";
    platforms = platforms.all;
  };
}
