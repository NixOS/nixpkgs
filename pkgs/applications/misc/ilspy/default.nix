{ lib
, stdenv
, pkgs

, fetchzip
, unzip
, autoPatchelfHook
, makeWrapper
, makeDesktopItem

#, stdenv.cc.cc.lib
, lttng-ust
, libkrb5
, zlib
, fontconfig

, openssl_1_1
, xorg
, libX11
, libICE
, libSM
, icu
}:
stdenv.mkDerivation rec {
  pname = "ILSpy";
  version = "7.2-rc";
  description = ".NET assembly browser and decompiler.";

  owner = "icsharpcode";
  repo = "AvaloniaILSpy";

  src = fetchzip {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/Linux.x64.Release.zip";
    sha256 = "sha256:1crf0ng4l6x70wjlz3r6qw8l166gd52ys11j7ilb4nyy3mkjxk11";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
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

  unpackPhase = ''unzip -qq ${src}/ILSpy-linux-x64-Release.zip'';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/icons/hicolor/scalable/apps
    cp -r artifacts/linux-x64/** $out/lib
    cp -r $desktopItem/share/applications $out/share
    ln -s $out/lib/Images/ILSpy.png $out/share/icons/hicolor/scalable/apps/${pname}.png

    chmod +x $out/lib/${pname}
    wrapProgram $out/lib/${pname} --prefix LD_LIBRARY_PATH : ${libraryPath}
    mv $out/lib/${pname} $out/bin
  '';

  # dotnet runtime requirements
  preFixup = ''patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so $out/lib/libcoreclrtraceptprovider.so'';
  dontStrip = true;

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = pname;
    exec = pname;
    icon = pname;
    comment = description;
    categories = [
      "Development"
    ];
    keywords = [
      ".net"
      "il"
      "assembly"
    ];
  };

  meta = with lib; {
    description = description;
    homepage = "https://github.com/${owner}/${repo}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ AngryAnt ];
  };
}
