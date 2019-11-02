{ stdenv, lib, qtbase, qtsvg, libglvnd, fetchurl, makeDesktopItem }:
stdenv.mkDerivation rec {
  pname = "write_stylus";
  version = "209";

  desktopItem = makeDesktopItem {
    name = "Write";
    exec = "Write";
    comment = "A word processor for handwriting";
    icon = "write_stylus";
    desktopName = "Write";
    genericName = "Write";
    categories = "Office;Graphics";
  };

  src = fetchurl {
    url = "http://www.styluslabs.com/write/write${version}.tar.gz";
    sha256 = "1p6glp4vdpwl8hmhypayc4cvs3j9jfmjfhhrgqm2xkgl5bfbv2qd";
  };

  # taken from: https://www.iconfinder.com/icons/50835/edit_pencil_write_icon
  # license: Free for commercial use
  icon = fetchurl {
    url = "https://oyra.eu/write/icon.tar.gz";
    sha256 = "1zd98g63apwi17qc1hm1g14maain5d18g4afadxm30qjz2s0mvs8";
  };

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -R Write $out/
    # symlink the binary to bin/
    ln -s $out/Write/Write $out/bin/Write

    # untar icons
    tar -xzf ${icon} *.tar.gz -C $out/

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';
  preFixup = let
    libPath = lib.makeLibraryPath [
      qtbase            # libQt5PrintSupport.so.5
      qtsvg             # libQt5Svg.so.5
      stdenv.cc.cc.lib  # libstdc++.so.6
      libglvnd          # ibGL.so.1
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/Write/Write
  '';

  meta = with stdenv.lib; {
    homepage = http://www.styluslabs.com/;
    description = "Write is a word processor for handwriting.";
    platforms = platforms.linux;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ oyren ];
  };
}
