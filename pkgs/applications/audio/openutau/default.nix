{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, dbus
, fontconfig
, libICE
, libSM
, libX11
, portaudio
}:

buildDotnetModule rec {
  pname = "OpenUtau";
  version = "0.1.158";

  src = fetchFromGitHub {
    owner = "stakira";
    repo = "OpenUtau";
    rev = "build/${version}";
    hash = "sha256-/+hlL2sj/juzWrDcb5dELp8Zdg688XK8OnjKz20rx/M=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  projectFile = "OpenUtau.sln";
  nugetDeps = ./deps.nix;

  executables = [ "OpenUtau" ];

  runtimeDeps = [
    dbus
    fontconfig
    libICE
    libSM
    libX11
    portaudio
  ];

  dotnetInstallFlags = [ "-p:PublishReadyToRun=false" ];

  # socket cannot bind to localhost on darwin for tests
  doCheck = !stdenv.isDarwin;

  # needed until upstream bumps to dotnet 7
  postPatch = ''
    substituteInPlace OpenUtau/OpenUtau.csproj OpenUtau.Test/OpenUtau.Test.csproj --replace \
      "<TargetFramework>net6.0</TargetFramework>" \
      "<TargetFramework>net7.0</TargetFramework>"
  '';

  # need to make sure proprietary worldline resampler is copied
  postInstall = let
    runtime = if (stdenv.isLinux && stdenv.isx86_64) then "linux-x64"
         else if (stdenv.isLinux && stdenv.isAarch64) then "linux-arm64"
         else if stdenv.isDarwin then "osx"
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
    license = with licenses; [
      # dotnet code
      mit
      # worldline resampler
      unfree
    ];
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
