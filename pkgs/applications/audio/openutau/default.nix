{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # Needed until stakira/OpenUtau#836 is merged and released to fix crashing issues. See stakira/OpenUtau#822
    (fetchpatch {
      name = "openutau-update-avalonia-to-11.0.4.patch";
      url = "https://github.com/stakira/OpenUtau/commit/0130d7387fb626a72850305dc61d7c175caccc0f.diff";
      hash = "sha256-w9PLnfiUtiKY/8+y4qqINeEul4kP72nKEVc5c8p2g7c=";
      # It looks like fetched files use CRLF but patch comes back with LF
      decode = "sed -e 's/$/\\r/'";
    })
  ];
  # Needs binary for above patch due to CRLF shenanigans otherwise being ignored
  patchFlags = [ "-p1" "--binary" ];

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
      '<TargetFramework>net6.0</TargetFramework>' \
      '<TargetFramework>net7.0</TargetFramework>'
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
      # dotnet code and worldline resampler binary
      mit
      # worldline resampler binary - no source is available (hence "unfree") but usage of the binary is MIT
      unfreeRedistributable
    ];
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
