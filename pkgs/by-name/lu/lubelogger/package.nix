{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "lubelogger";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "hargata";
    repo = "lubelog";
    rev = "v${version}";
    hash = "sha256-22I4OJZLeFLstGZF1fY/s8Y5tPgGJpJR/sPZpkHvUmY=";
  };

  projectFile = "CarCareTracker.sln";
  nugetDeps = ./deps.nix; # File generated with `nix-build -A package.passthru.fetch-deps`.

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  makeWrapperArgs = [
    "--set DOTNET_CONTENTROOT ${placeholder "out"}/lib/lubelogger"
  ];

  executables = [ "CarCareTracker" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.

  meta = with lib; {
    description = "A vehicle service records and maintainence tracker";
    longDescription = ''
      A self-hosted, open-source, unconventionally-named vehicle maintenance records and fuel mileage tracker.

      LubeLogger by Hargata Softworks is licensed under the MIT License for individual and personal use. Commercial users and/or corporate entities are required to maintain an active subscription in order to continue using LubeLogger.
    '';
    homepage = "https://lubelogger.com";
    changelog = "https://github.com/hargata/lubelog/releases/tag/v${version}";
    license = licenses.unfree;
    maintainers = with maintainers; [ samasaur ];
    mainProgram = "CarCareTracker";
    platforms = platforms.all;
  };
}
