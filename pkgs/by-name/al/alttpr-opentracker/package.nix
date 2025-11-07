{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  autoPatchelfHook,
  wrapGAppsHook3,
  dotnetCorePackages,
  fontconfig,
  gtk3,
  icu,
  libkrb5,
  libunwind,
  openssl,
  xinput,
  xorg,
}:
buildDotnetModule rec {
  pname = "opentracker";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "trippsc2";
    repo = "opentracker";
    tag = version;
    hash = "sha256-4EBn3BX5tX+yPUjoNFQSls9CwTCd6MpvcBoUKwRndRo=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  nugetDeps = ./deps.json;

  projectFile = "src/OpenTracker/OpenTracker.csproj";
  executables = [ "OpenTracker" ];

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    fontconfig
    gtk3
    icu
    libkrb5
    libunwind
    openssl
  ];

  runtimeDeps = [
    gtk3
    openssl
    xinput
  ]
  ++ (with xorg; [
    libICE
    libSM
    libX11
    libXi
  ]);

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
    "libintl.so.8"
  ];

  meta = with lib; {
    description = "Tracking application for A Link to the Past Randomizer";
    homepage = "https://github.com/trippsc2/OpenTracker";
    sourceProvenance = with sourceTypes; [
      fromSource
      # deps
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "OpenTracker";
    platforms = [ "x86_64-linux" ];
  };
}
