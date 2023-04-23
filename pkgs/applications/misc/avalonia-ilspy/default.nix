{ lib
, stdenv
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
, openssl_1_1
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
    openssl_1_1
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

  meta = with lib; {
    description = ".NET assembly browser and decompiler";
    homepage = "https://github.com/icsharpcode/AvaloniaILSpy";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ AngryAnt ];
  };
}
