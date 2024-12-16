{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
buildDotnetModule rec {
  pname = "msbuild-project-tools-server";
  version = "0.6.6";
  src = fetchFromGitHub {
    owner = "tintoy";
    repo = "msbuild-project-tools-server";
    rev = "v${version}";
    hash = "sha256-dhE94gnH8s758a9JmdMXV2/7nzm4JD6mcVaq75NRXLQ=";
  };

  nugetDeps = ./deps.nix;
  projectFile = "src/LanguageServer/LanguageServer.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_8_0_1xx;
  useDotnetFromEnv = true;

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
