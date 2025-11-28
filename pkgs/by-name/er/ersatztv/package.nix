{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  ffmpeg,
  which,
}:

buildDotnetModule rec {
  pname = "ersatztv";
  version = "25.8.0";

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "ErsatzTV";
    rev = "v${version}";
    sha256 = "sha256-FuuX/SxhzzUn7ELJDXJuILkl3ubR3V+5hQwILvZZrFg=";
  };

  buildInputs = [ ffmpeg ];

  projectFile = "ErsatzTV/ErsatzTV.csproj";
  executables = [
    "ErsatzTV"
    "ErsatzTV.Scanner"
  ];
  nugetDeps = ./nuget-deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

  # ETV uses `which` to find `ffmpeg` and `ffprobe`
  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      ffmpeg
      which
    ]}"
  ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Stream custom live channels using your own media";
    homepage = "https://ersatztv.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ allout58 ];
    mainProgram = "ErsatzTV";
    platforms = dotnet-runtime.meta.platforms;
  };
}
