{
  mkDerivation,
  stdenv,
  lib,
  qtbase,
  qtsvg,
  libglvnd,
  libX11,
  libXi,
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
mkDerivation rec {
  pname = "write_stylus";
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
        qtbase # libQt5PrintSupport.so.5
        qtsvg # libQt5Svg.so.5
        stdenv.cc.cc.lib # libstdc++.so.6
        libglvnd # libGL.so.1
        libX11 # libX11.so.6
        libXi # libXi.so.6
      ];
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/Write/Write
    '';

  meta = with lib; {
    homepage = "http://www.styluslabs.com/";
    description = "Write is a word processor for handwriting";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ oyren ];
  };
}
