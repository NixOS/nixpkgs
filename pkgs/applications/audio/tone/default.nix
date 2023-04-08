{ lib, stdenv, fetchFromGitHub, fetchNuGet, linkFarmFromDrvs, buildDotnetModule, ffmpeg-full, msbuild, dotnetCorePackages }:

let
  nugetSource = linkFarmFromDrvs "nuget-packages" (
    import ./nuget-deps.nix { inherit fetchNuGet; }
  );

in buildDotnetModule rec {
  pname = "tone";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "sandreas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z3cumXAIJhUB3/EbzB08MfBCrga1JHtDKr44TmRQuno=";
  };

  projectFile = "tone/tone.csproj";
  executables = [ "tone" ];
  nugetDeps = ./nuget-deps.nix;
  dotnetBuildFlags = [ "--no-self-contained" ];
  dotnetInstallFlags = [
    "-p:PublishSingleFile=false"
    "-p:PublishTrimmed=false"
    "-p:PublishReadyToRun=false"
  ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  runtimeDeps = [ ffmpeg-full ];

  meta = with lib; {
    homepage = "https://github.com/sandreas/tone";
    description = "tone is a cross platform utility to dump and modify audio metadata for a wide variety of formats";
    license = licenses.asl20;
    maintainers = [ maintainers.jvanbruegge ];
    platforms = platforms.linux;
  };
}
