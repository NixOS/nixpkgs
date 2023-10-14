{ lib
, stdenv
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, libX11
, libICE
, libSM
, libXi
, libXcursor
, libXext
, libXrandr
, fontconfig
, glew
, makeDesktopItem
, copyDesktopItems
, icoutils
, autoPatchelfHook
, bintools
, fixDarwinDylibNames
, autoSignDarwinBinariesHook
}:

buildDotnetModule rec {
  pname = "avalonia-ilspy";
  version = "7.2-rc";

  src = fetchFromGitHub {
    owner = "icsharpcode";
    repo = "AvaloniaILSpy";
    rev = "v${version}";
    sha256 = "cCQy5cSpJNiVZqgphURcnraEM0ZyXGhzJLb5AThNfPQ=";
  };

  patches = [
    # Remove dead nuget package source
    ./remove-broken-sources.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ bintools fixDarwinDylibNames ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [ autoSignDarwinBinariesHook ];

  buildInputs = [
    # Dependencies of nuget packages w/ native binaries
    stdenv.cc.cc.lib
    fontconfig
  ];

  runtimeDeps = [
    # Avalonia UI
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
    glew
  ];

  postInstall = ''
    icotool --icon -x ILSpy/ILSpy.ico
    for i in 16 32 48 256; do
      size=''${i}x''${i}
      install -Dm444 *_''${size}x32.png $out/share/icons/hicolor/$size/apps/ILSpy.png
    done
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm444 ILSpy/Info.plist $out/Applications/ILSpy.app/Contents/Info.plist
    install -Dm444 ILSpy/ILSpy.icns $out/Applications/ILSpy.app/Contents/Resources/ILSpy.icns
    mkdir -p $out/Applications/ILSpy.app/Contents/MacOS
    ln -s $out/bin/ILSpy $out/Applications/ILSpy.app/Contents/MacOS/ILSpy
  '';

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  projectFile = "ILSpy/ILSpy.csproj";
  nugetDeps = ./deps.nix;
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
    sourceProvenance = with sourceTypes; [ fromSource binaryBytecode binaryNativeCode ];
    maintainers = with maintainers; [ AngryAnt emilytrau ];
    mainProgram = "ILSpy";
  };
}
