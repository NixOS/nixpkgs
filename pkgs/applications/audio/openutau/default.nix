{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, dbus
, fontconfig
, portaudio
}:

buildDotnetModule rec {
  pname = "OpenUtau";
  version = "0.1.529";

  src = fetchFromGitHub {
    owner = "stakira";
    repo = "OpenUtau";
    rev = "build/${version}";
    hash = "sha256-HE0KxPKU7tYZbYiCL8sm6I/NZiX0MJktt+5d6qB1A2E=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  # [...]/Microsoft.NET.Sdk.targets(157,5): error MSB4018: The "GenerateDepsFile" task failed unexpectedly. [[...]/OpenUtau.Core.csproj]
  # [...]/Microsoft.NET.Sdk.targets(157,5): error MSB4018: System.IO.IOException: The process cannot access the file '[...]/OpenUtau.Core.deps.json' because it is being used by another process. [[...]/OpenUtau.Core.csproj]
  enableParallelBuilding = false;

  projectFile = "OpenUtau.sln";
  nugetDeps = ./deps.json;

  executables = [ "OpenUtau" ];

  runtimeDeps = [
    dbus
    portaudio
  ];

  dotnetInstallFlags = [ "-p:PublishReadyToRun=false" ];

  # socket cannot bind to localhost on darwin for tests
  doCheck = !stdenv.hostPlatform.isDarwin;

  # net8.0 replacement needed until upstream bumps to dotnet 8
  postPatch = ''
    substituteInPlace OpenUtau/OpenUtau.csproj OpenUtau.Test/OpenUtau.Test.csproj --replace \
      '<TargetFramework>net6.0</TargetFramework>' \
      '<TargetFramework>net8.0</TargetFramework>'

    substituteInPlace OpenUtau/Program.cs --replace \
      '/usr/bin/fc-match' \
      '${lib.getExe' fontconfig "fc-match"}'
  '';

  # need to make sure proprietary worldline resampler is copied
  postInstall = let
    runtime = if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) then "linux-x64"
         else if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) then "linux-arm64"
         else if stdenv.hostPlatform.isDarwin then "osx"
         else null;
  in lib.optionalString (runtime != null) ''
    cp runtimes/${runtime}/native/libworldline${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/OpenUtau/
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Open source singing synthesis platform and UTAU successor";
    homepage = "http://www.openutau.com/";
    sourceProvenance = with sourceTypes; [
      fromSource
      # deps
      binaryBytecode
      # some deps and worldline resampler
      binaryNativeCode
    ];
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "OpenUtau";
  };
}
