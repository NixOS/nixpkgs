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
  version = "25.9.0";

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "ErsatzTV";
    rev = "v${version}";
    sha256 = "sha256-+ZMDMKrJN+nX9FeSZ8RTFGRf161Mhpqd7jY9FLZWNqM=";
  };
  postPatch = ''
    # Remove config of development tools that don't end up in
    # nuget-deps.json but would be looked up at build time
    # leading to a missing package error.
    rm -r .config
  '';

  buildInputs = [ ffmpeg ];

  projectFile = "ErsatzTV/ErsatzTV.csproj";
  executables = [
    "ErsatzTV"
    "ErsatzTV.Scanner"
  ];
  nugetDeps = ./nuget-deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

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
