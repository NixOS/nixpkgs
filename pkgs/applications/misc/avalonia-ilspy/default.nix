{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  fontconfig,
  glibc,
  gtk3,
  libGL,
  libICE,
  libSM,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  makeDesktopItem,
  copyDesktopItems,
  icoutils,
  bintools,
  fixDarwinDylibNames,
  autoPatchcilHook,
  autoSignDarwinBinariesHook,
}:

buildDotnetModule rec {
  pname = "avalonia-ilspy";
  version = "7.2-rc";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "AvaloniaILSpy";
    rev = "v${version}";
    hash = "sha256-cCQy5cSpJNiVZqgphURcnraEM0ZyXGhzJLb5AThNfPQ=";
  };

  patches = [
    # Remove dead nuget package source
    ./remove-broken-sources.patch
    # Upgrade project to .NET 8.0
    ./dotnet-8-upgrade.patch
  ];

  nativeBuildInputs =
    [
      autoPatchcilHook
      copyDesktopItems
      icoutils
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      bintools
      fixDarwinDylibNames
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      autoSignDarwinBinariesHook
    ];

  buildInputs = [
    # Dependencies of nuget packages w/ native binaries
    (lib.getLib stdenv.cc.cc)
    fontconfig

    # autoPatchcil
    glibc # libdl
    gtk3 # libglib-2.0.so.0 libgobject-2.0.so.0 libgtk-3.so.0 libgdk-3.so.0
    libGL # libGL.so.1
    libICE # libICE.so.6
    libSM # libSM.so.6
    libX11 # libX11 libX11.so.6
    libXcursor # libXcursor.so.1
    libXi # libXi.so.6
    libXrandr # libXrandr.so.2
  ];

  autoPatchcilIgnoreMissingDeps = [
    # libc is loaded in a different way, but it works without patchcil
    "c"
    "libc"

    # Windows libraries
    "gdi32"
    "kernel32"
    "ntdll"
    "shell32"
    "user32"
    "Windows.UI.Composition"
    "winspool.drv"

    # Darwin libraries
    "libAvaloniaNative"

    # .NET Runtime
    "clr"
  ];

  runtimeDeps = [
    # Skia
    fontconfig
  ];

  postInstall =
    ''
      icotool --icon -x ILSpy/ILSpy.ico
      for i in 16 32 48 256; do
        size=''${i}x''${i}
        install -Dm444 *_''${size}x32.png $out/share/icons/hicolor/$size/apps/ILSpy.png
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -Dm444 ILSpy/Info.plist $out/Applications/ILSpy.app/Contents/Info.plist
      install -Dm444 ILSpy/ILSpy.icns $out/Applications/ILSpy.app/Contents/Resources/ILSpy.icns
      mkdir -p $out/Applications/ILSpy.app/Contents/MacOS
      ln -s $out/bin/ILSpy $out/Applications/ILSpy.app/Contents/MacOS/ILSpy
    '';

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  projectFile = "ILSpy/ILSpy.csproj";
  nugetDeps = ./deps.json;
  executables = [ "ILSpy" ];

  desktopItems = [
    (makeDesktopItem {
      name = "ILSpy";
      desktopName = "ILSpy";
      exec = "ILSpy";
      icon = "ILSpy";
      comment = ".NET assembly browser and decompiler";
      categories = [
        "Development"
      ];
      keywords = [
        ".net"
        "il"
        "assembly"
      ];
    })
  ];

  meta = with lib; {
    description = ".NET assembly browser and decompiler";
    homepage = "https://github.com/icsharpcode/AvaloniaILSpy";
    license = with licenses; [
      mit
      # third party dependencies
      lgpl21Only
      mspl
    ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
    maintainers = with maintainers; [
      AngryAnt
      emilytrau
    ];
    mainProgram = "ILSpy";
  };
}
