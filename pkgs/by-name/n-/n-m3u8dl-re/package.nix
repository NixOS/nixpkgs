{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
buildDotnetModule rec {
  pname = "n-m3u8dl-re";
  version = "0.3.0-beta";
  src = fetchFromGitHub {
    owner = "nilaoda";
    repo = "N_m3u8DL-RE";
    tag = "v${version}";
    sha256 = "sha256-AVLO7pxD1LCoogsJPPN5aoOmVBIm3Y/EVsiQWdYI6QU=";
  };
  patches = [
    ./publish-fix.patch
    ./reverse-arr.patch
  ];

  # from openutau/default.nix
  # [...]/Microsoft.NET.Sdk/targets/Microsoft.NET.Sdk.targets(248,5): error MSB4018: The "GenerateDepsFile" task failed unexpectedly. [[...]/N_m3u8DL-RE.Common.csproj]
  # [...]/Microsoft.NET.Sdk/targets/Microsoft.NET.Sdk.targets(248,5): error MSB4018: System.IO.IOException: The process cannot access the file '[...]/N_m3u8DL-RE.Common.deps.json' because it is being used by another process. [[...]/N_m3u8DL-RE.Common.csproj]
  enableParallelBuilding = false;

  projectFile = "src/N_m3u8DL-RE.sln";
  nugetDeps = ./deps.json;

  executables = [ "N_m3u8DL-RE" ];

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  postFixup = ''
    ln -s $out/bin/N_m3u8DL-RE $out/bin/n-m3u8dl-re
  '';

  meta = {
    description = "Cross-Platform, modern and powerful stream downloader for MPD/M3U8/ISM";
    homepage = "https://github.com/nilaoda/N_m3u8DL-RE";
    license = lib.licenses.mit;
    mainProgram = "n-m3u8dl-re";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.linux ++ lib.platforms.unix;
  };
}
