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
<<<<<<< HEAD
  version = "25.9.0";
=======
  version = "25.8.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ErsatzTV";
    repo = "ErsatzTV";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+ZMDMKrJN+nX9FeSZ8RTFGRf161Mhpqd7jY9FLZWNqM=";
  };
  postPatch = ''
    # Remove config of development tools that don't end up in
    # nuget-deps.json but would be looked up at build time
    # leading to a missing package error.
    rm -r .config
  '';
=======
    sha256 = "sha256-FuuX/SxhzzUn7ELJDXJuILkl3ubR3V+5hQwILvZZrFg=";
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  buildInputs = [ ffmpeg ];

  projectFile = "ErsatzTV/ErsatzTV.csproj";
  executables = [
    "ErsatzTV"
    "ErsatzTV.Scanner"
  ];
  nugetDeps = ./nuget-deps.json;
<<<<<<< HEAD
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;
=======
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Stream custom live channels using your own media";
    homepage = "https://ersatztv.org/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ allout58 ];
=======
  meta = with lib; {
    description = "Stream custom live channels using your own media";
    homepage = "https://ersatztv.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [ allout58 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ErsatzTV";
    platforms = dotnet-runtime.meta.platforms;
  };
}
