{ lib
, stdenv
<<<<<<< HEAD
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
=======
, fetchzip
, unzip
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, lttng-ust
, libkrb5
, zlib
, fontconfig
, openssl
, libX11
, libICE
, libSM
, icu
}:

stdenv.mkDerivation rec {
  pname = "avalonia-ilspy";
  version = "7.2-rc";

  src = fetchzip {
    url = "https://github.com/icsharpcode/AvaloniaILSpy/releases/download/v${version}/Linux.x64.Release.zip";
    sha256 = "1crf0ng4l6x70wjlz3r6qw8l166gd52ys11j7ilb4nyy3mkjxk11";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    lttng-ust
    libkrb5
    zlib
    fontconfig
  ];

  libraryPath = lib.makeLibraryPath [
    openssl
    libX11
    libICE
    libSM
    icu
  ];

  unpackPhase = ''
    unzip -qq $src/ILSpy-linux-x64-Release.zip
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share/icons/hicolor/scalable/apps
    cp -r artifacts/linux-x64/* $out/lib
    ln -s $out/lib/Images/ILSpy.png $out/share/icons/hicolor/scalable/apps/ILSpy.png

    chmod +x $out/lib/ILSpy
    wrapProgram $out/lib/ILSpy --prefix LD_LIBRARY_PATH : ${libraryPath}
    mv $out/lib/ILSpy $out/bin

    runHook postInstall
  '';

  # dotnet runtime requirements
  preFixup = ''
    patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so $out/lib/libcoreclrtraceptprovider.so
  '';
  dontStrip = true;

  desktopItems = [ (makeDesktopItem {
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
  }) ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = ".NET assembly browser and decompiler";
    homepage = "https://github.com/icsharpcode/AvaloniaILSpy";
<<<<<<< HEAD
    license = with licenses; [
      mit
      # third party dependencies
      lgpl21Only
      mspl
    ];
    sourceProvenance = with sourceTypes; [ fromSource binaryBytecode binaryNativeCode ];
    maintainers = with maintainers; [ AngryAnt emilytrau ];
    mainProgram = "ILSpy";
=======
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ AngryAnt ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
