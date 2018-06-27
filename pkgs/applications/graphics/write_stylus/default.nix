{ stdenv, lib, qt5, makeWrapper, fetchurl, makeDesktopItem }:
stdenv.mkDerivation rec {
  name = "write_stylus";

  desktopItem = makeDesktopItem {
    name = "Write";
    exec = "Write";
    comment = "a word processor for hadwriting";
    desktopName = "Write";
    genericName = "Write";
    categories = "Office;Graphics";
  };

  src = fetchurl {
    url = "http://www.styluslabs.com/write/write209.tar.gz";
    sha256 = "1p6glp4vdpwl8hmhypayc4cvs3j9jfmjfhhrgqm2xkgl5bfbv2qd";
  };
  sourceRoot = ".";
  unpackCmd = ''
    tar xfz "$src"
    '';

  buildPhase = ":";   # nothing to build

  installPhase = ''
    mkdir -p $out/bin
    cp -R Write $out/
    # symlink the binary to bin/
    ln -s $out/Write/Write $out/bin/Write

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';
  preFixup = let
    libPath = lib.makeLibraryPath [
      qt5.qtbase        # libQt5PrintSupport.so.5
      qt5.qtsvg         # libQt5Svg.so.5
      stdenv.cc.cc.lib  # libstdc++.so.6
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
    maintainers = [ "m.scheuren@oyra.eu" ];
  };
}
