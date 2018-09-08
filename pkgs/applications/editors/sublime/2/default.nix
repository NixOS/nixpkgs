{ fetchurl, stdenv, glib, xorg, cairo, gtk2, makeDesktopItem }:
let
  libPath = stdenv.lib.makeLibraryPath [glib xorg.libX11 gtk2 cairo];
in

stdenv.mkDerivation rec {
  name = "sublimetext-2.0.2";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        name = "sublimetext-2.0.2.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2.tar.bz2;
        sha256 = "026g5mppk28lzzzn9ibykcqkrd5msfmg0sc0z8w8jd7v3h28wcq7";
      }
    else
      fetchurl {
        name = "sublimetext-2.0.2.tar.bz2";
        url = http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2;
        sha256 = "115b71nbv9mv8cz6bkjwpbdf2ywnjc1zy2d3080f6ck4sqqfvfh1";
      };
  buildCommand = ''
    tar xvf ${src}
    mkdir -p $out/bin
    mv Sublime* $out/sublime
    ln -s $out/sublime/sublime_text $out/bin/sublime
    ln -s $out/sublime/sublime_text $out/bin/sublime2

    echo ${libPath}
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
      $out/sublime/sublime_text

    mkdir -p $out/share/icons

    for x in $(ls $out/sublime/Icon); do
      mkdir -p $out/share/icons/hicolor/$x/apps
      cp -v $out/sublime/Icon/$x/* $out/share/icons/hicolor/$x/apps
    done

    ln -sv "${desktopItem}/share/applications" $out/share
  '';

  desktopItem = makeDesktopItem {
    name = "sublime2";
    exec = "sublime2 %F";
    comment = meta.description;
    desktopName = "Sublime Text";
    genericName = "Text Editor";
    categories = "TextEditor;Development;";
    icon = "sublime_text";
  };

  meta = {
    description = "Sophisticated text editor for code, markup and prose";
    license = stdenv.lib.licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
