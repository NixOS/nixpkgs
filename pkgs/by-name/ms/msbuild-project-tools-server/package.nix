{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
let
  owner = "tintoy";
  repo = "msbuild-project-tools-server";
  dotnet-sdk = dotnetCorePackages.sdk_8_0_1xx;
in
buildDotnetModule rec {
  pname = repo;
  version = "0.6.6";
  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    hash = "sha256-dhE94gnH8s758a9JmdMXV2/7nzm4JD6mcVaq75NRXLQ=";
  };

  nugetDeps = ./deps.nix;
  projectFile = "src/LanguageServer/LanguageServer.csproj";
  inherit dotnet-sdk;
  # useDotnetFromEnv = true;

  meta = with lib; {
    description = "Language server for MSBuild intellisense";
    homepage = "https://github.com/tintoy/msbuild-project-tools-server";
    changelog = "https://github.com/tintoy/msbuild-project-tools-server/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sharpchen ];
    platforms = lib.platforms.unix;
    mainProgram = "MSBuildProjectTools.LanguageServer.Host";
  };
}
