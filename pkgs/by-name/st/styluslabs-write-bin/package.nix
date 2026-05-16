{
  stdenv,
  lib,
  libsForQt5,
  libglvnd,
  libx11,
  libxi,
  fetchurl,
  makeDesktopItem,
}:
let
  desktopItem = makeDesktopItem {
    name = "Write";
    exec = "Write";
    comment = "A word processor for handwriting";
    icon = "write_stylus";
    desktopName = "Write";
    genericName = "Write";
    categories = [
      "Office"
      "Graphics"
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "styluslabs-write-bin";
  version = "300";

  src = fetchurl {
    url = "http://www.styluslabs.com/write/write${version}.tar.gz";
    sha256 = "0h1wf3af7jzp3f3l8mlnshi83d7a4v4y8nfqfai4lmskyicqlz7c";
  };

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -R Write $out/
    # symlink the binary to bin/
    ln -s $out/Write/Write $out/bin/Write

    # Create desktop item
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
    mkdir -p $out/share/icons
    ln -s $out/Write/Write144x144.png $out/share/icons/write_stylus.png
  '';
  preFixup =
    let
      libPath = lib.makeLibraryPath [
        libsForQt5.qtbase # libQt5PrintSupport.so.5
        libsForQt5.qtsvg # libQt5Svg.so.5
        (lib.getLib stdenv.cc.cc) # libstdc++.so.6
        libglvnd # libGL.so.1
        libx11 # libX11.so.6
        libxi # libXi.so.6
      ];
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/Write/Write
    '';

  meta = {
    homepage = "http://www.styluslabs.com/";
    description = "Write is a word processor for handwriting";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.linux;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      oyren
      lukts30
      atemu
    ];
  };
}
