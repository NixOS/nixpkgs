{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  ersatztv-next,
  bash,
  ffmpeg,
  which,
  nixosTests,
}:

buildDotnetModule rec {
  pname = "ersatztv";
  version = "26.11.6";

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "legacy";
    rev = "v${version}";
    sha256 = "sha256-Z6kvKPiEc3YQPexZ0U30crgSt2HC3nDhlFpw/6KosQU=";
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

  dotnetFlags = [ "-p:TreatWarningsAsErrors=false" ];
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  # ETV uses `which` to find `ffmpeg` and `ffprobe`
  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      bash
      ffmpeg
      which
    ]}"
    # ETV otherwise looks for ersatztv-channel next to its own executable
    "--set-default"
    "ETV_NEXT_FOLDER"
    "${ersatztv-next}/bin"
  ];

  passthru = {
    updateScript = ./update.sh;
    tests = { inherit (nixosTests) ersatztv; };
  };

  meta = {
    description = "Stream custom live channels using your own media";
    homepage = "https://ersatztv.org/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      allout58
      font44
    ];
    mainProgram = "ErsatzTV";
    platforms = dotnet-runtime.meta.platforms;
  };
}
