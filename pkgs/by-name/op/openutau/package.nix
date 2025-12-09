{
  alsa-lib,
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  dbus,
  fontconfig,
  portaudio,
  libXi,
  copyDesktopItems,
  makeDesktopItem,
}:

buildDotnetModule rec {
  pname = "OpenUtau";
  version = "0.1.565";

  src = fetchFromGitHub {
    owner = "stakira";
    repo = "OpenUtau";
    tag = version;
    hash = "sha256-tjW1xmt409AlEmw/N1RG46oigP4mWAoTecQGV/hwMo4=";
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
      categories = [
        "AudioVideo"
        "Music"
      ];
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    libXi
  ];

  dotnetInstallFlags = [ "-p:PublishReadyToRun=false" ];

  # socket cannot bind to localhost on darwin for tests
  doCheck = !stdenv.hostPlatform.isDarwin;

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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "OpenUtau";
  };
}
