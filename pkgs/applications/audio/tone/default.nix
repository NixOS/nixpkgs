{ lib, fetchFromGitHub, buildDotnetModule, ffmpeg-full, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "tone";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "sandreas";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HhXyOPoDtraT7ef0kpE7SCQbvGFLrTddzS6Kdu0LxW4=";
  };

  projectFile = "tone/tone.csproj";
  executables = [ "tone" ];
  nugetDeps = ./nuget-deps.nix;
<<<<<<< HEAD

  dotnetInstallFlags = [
    "-p:PublishSingleFile=false"
=======
  dotnetBuildFlags = [ "--no-self-contained" ];
  dotnetInstallFlags = [
    "-p:PublishSingleFile=false"
    "-p:PublishTrimmed=false"
    "-p:PublishReadyToRun=false"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  runtimeDeps = [ ffmpeg-full ];

  meta = with lib; {
    homepage = "https://github.com/sandreas/tone";
    description = "A cross platform utility to dump and modify audio metadata for a wide variety of formats";
    license = licenses.asl20;
    maintainers = [ maintainers.jvanbruegge ];
<<<<<<< HEAD
    platforms = platforms.linux;
=======
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
