{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  sqlite,
  ffmpeg,
  which,
}:

buildDotnetModule rec {
  pname = "ersatztv";
  version = "0.8.7-beta";

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "ErsatzTV";
    rev = "v${version}";
    sha256 = "sha256-G3yw9aYZABEyghCddpAoO71wrjVbWiVJALEMZSbr2Lg=";
  };

  propagatedBuildInputs = [ sqlite ];

  buildInputs = [ ffmpeg ];

  projectFile = "ErsatzTV/ErsatzTV.csproj";
  executables = [
    "ErsatzTV"
    "ErsatzTV.Scanner"
  ];
  nugetDeps = ./nuget-deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

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
    description = "Configuring and streaming custom live channels using your media library";
    homepage = "https://ersatztv.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ allout58 ];
    mainProgram = "ErsatzTV";
    platforms = dotnet-runtime.meta.platforms;
  };
}
