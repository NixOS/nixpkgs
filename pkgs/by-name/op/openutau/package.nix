{
<<<<<<< HEAD
  alsa-lib,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  dbus,
  fontconfig,
  portaudio,
<<<<<<< HEAD
  libXi,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  copyDesktopItems,
  makeDesktopItem,
}:

buildDotnetModule rec {
  pname = "OpenUtau";
<<<<<<< HEAD
  version = "0.1.565";
=======
  version = "0.1.529";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "stakira";
    repo = "OpenUtau";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-tjW1xmt409AlEmw/N1RG46oigP4mWAoTecQGV/hwMo4=";
=======
    rev = "build/${version}";
    hash = "sha256-HE0KxPKU7tYZbYiCL8sm6I/NZiX0MJktt+5d6qB1A2E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "openutau";
      desktopName = "OpenUtau";
      startupWMClass = "openutau";
      icon = "openutau";
      genericName = "Utau";
      comment = "Open source UTAU successor";
      exec = "OpenUtau";
<<<<<<< HEAD
      categories = [
        "AudioVideo"
        "Music"
      ];
=======
      categories = [ "Music" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
  ];

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
<<<<<<< HEAD
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    libXi
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  dotnetInstallFlags = [ "-p:PublishReadyToRun=false" ];

  # socket cannot bind to localhost on darwin for tests
  doCheck = !stdenv.hostPlatform.isDarwin;

<<<<<<< HEAD
=======
  # net8.0 replacement needed until upstream bumps to dotnet 8
  postPatch = ''
    substituteInPlace OpenUtau/OpenUtau.csproj OpenUtau.Test/OpenUtau.Test.csproj --replace \
      '<TargetFramework>net6.0</TargetFramework>' \
      '<TargetFramework>net8.0</TargetFramework>'

    substituteInPlace OpenUtau/Program.cs --replace \
      '/usr/bin/fc-match' \
      '${lib.getExe' fontconfig "fc-match"}'
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # need to make sure proprietary worldline resampler is copied
  postInstall =
    let
      runtime =
        if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) then
          "linux-x64"
        else if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) then
          "linux-arm64"
        else if stdenv.hostPlatform.isDarwin then
          "osx"
        else
          null;
      shouldInstallResampler = lib.optionalString (runtime != null) ''
        cp runtimes/${runtime}/native/libworldline${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/OpenUtau/
      '';
      shouldInstallDesktopItem = lib.optionalString stdenv.hostPlatform.isLinux ''
        install -Dm655 -t $out/share/icons/hicolor/scalable/apps Logo/openutau.svg
      '';
    in
    ''
      ${shouldInstallResampler}
      ${shouldInstallDesktopItem}
    '';

  passthru.updateScript = ./update.sh;

<<<<<<< HEAD
  meta = {
    description = "Open source singing synthesis platform and UTAU successor";
    homepage = "http://www.openutau.com/";
    sourceProvenance = with lib.sourceTypes; [
=======
  meta = with lib; {
    description = "Open source singing synthesis platform and UTAU successor";
    homepage = "http://www.openutau.com/";
    sourceProvenance = with sourceTypes; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      fromSource
      # deps
      binaryBytecode
      # some deps and worldline resampler
      binaryNativeCode
    ];
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "OpenUtau";
  };
}
