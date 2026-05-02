{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
}:
buildDotnetModule (finalAttrs: {
  pname = "fracjson";
  version = "cli-v1.0.1";

  src = fetchFromGitHub {
    owner = "j-brooke";
    repo = "FracturedJson";
    rev = finalAttrs.version;
    sha256 = "sha256-JdCDL6kTGUT2bgKLXw9aHThuSNxeSOtFm2besvFw814=";
  };

  projectFile = "Cli/Cli.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  # Compression in single-file bundles requires self-contained builds;
  # override the .csproj setting for framework-dependent Nix packaging.
  dotnetInstallFlags = [ "-p:EnableCompressionInSingleFile=false" ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "JSON formatter that produces compact, highly readable output";
    homepage = "https://github.com/j-brooke/FracturedJson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ allsimon ];
    platforms = lib.platforms.all;
  };
})
