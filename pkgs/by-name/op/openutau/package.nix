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
  libxi,
  copyDesktopItems,
  makeDesktopItem,
}:

buildDotnetModule rec {
  pname = "OpenUtau";
  version = "0.1.576";

  src = fetchFromGitHub {
    owner = "openutau";
    repo = "OpenUtau";
    tag = version;
    hash = "sha256-4lbwv8F+RRSbj9QBVTdof6zec7uMj5i9ROID2l/F9yk=";
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

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  # [...]/Microsoft.NET.Sdk.targets(157,5): error MSB4018: The "GenerateDepsFile" task failed unexpectedly. [[...]/OpenUtau.Core.csproj]
  # [...]/Microsoft.NET.Sdk.targets(157,5): error MSB4018: System.IO.IOException: The process cannot access the file '[...]/OpenUtau.Core.deps.json' because it is being used by another process. [[...]/OpenUtau.Core.csproj]
  enableParallelBuilding = false;

  projectFile = "OpenUtau/OpenUtau.csproj";
  nugetDeps = ./deps.json;

  executables = [ "OpenUtau" ];

  runtimeDeps = [
    dbus
    portaudio
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    libxi
  ];

  dotnetInstallFlags = [ "-p:PublishReadyToRun=false" ];

  # socket cannot bind to localhost on darwin for tests +
  #
  # Testing with VSTest target is no longer supported
  # by Microsoft.Testing.Platform on .NET 10 SDK and later.
  doCheck = false;

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

  meta = {
    description = "Open source singing synthesis platform and UTAU successor";
    homepage = "http://www.openutau.com/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # deps
      binaryBytecode
      # some deps and worldline resampler
      binaryNativeCode
    ];
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "OpenUtau";
  };
}
