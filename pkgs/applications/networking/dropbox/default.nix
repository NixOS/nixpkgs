{ stdenv, fetchurl, makeDesktopItem
, libSM, libX11, libXext, libXcomposite, libXcursor, libXdamage
, libXfixes, libXi, libXinerama, libXrandr, libXrender
, dbus, dbus_glib, fontconfig, gcc, patchelf
, atk, glib, gdk_pixbuf, gtk, pango, zlib
}:

# this package contains the daemon version of dropbox
# it's unfortunately closed source
#
# note: the resulting program has to be invoced as
# 'dropbox' because the internal python engine takes
# uses the name of the program as starting point.
#
# todo: dropbox is shipped with some copies of libraries.
# replace these libraries with the appropriate ones in
# nixpkgs.

let
  arch = if stdenv.system == "x86_64-linux" then "x86_64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "Dropbox client for: ${stdenv.system} not supported!";

  interpreter = if stdenv.system == "x86_64-linux" then "ld-linux-x86-64.so.2"
    else if stdenv.system == "i686-linux" then "ld-linux.so.2"
    else throw "Dropbox client for: ${stdenv.system} not supported!";

  version = "2.10.30";
  sha256 = if stdenv.system == "x86_64-linux" then "1gdch4fka5f671zwl329j6b60igki1rzxw9ggxcywcg1h4rlvw7r"
    else if stdenv.system == "i686-linux" then "1a4pswpy945iqzvi8kcs1r0sydb04h28v5zv0hdyra0c548wsm2g"
    else throw "Dropbox client for: ${stdenv.system} not supported!";

  # relative location where the dropbox libraries are stored
  appdir = "opt/dropbox";

  # Libraries referenced by dropbox binary.
  # Be aware that future versions of the dropbox binary may refer
  # to different versions than are currently in these packages.
  ldpath = stdenv.lib.makeSearchPath "lib" [
      libSM libX11 libXext libXcomposite libXcursor libXdamage
      libXfixes libXi libXinerama libXrandr libXrender
      atk dbus dbus_glib glib fontconfig gcc gdk_pixbuf
      gtk pango zlib
    ];

  desktopItem = makeDesktopItem {
    name = "dropbox";
    exec = "dropbox";
    comment = "Online directories";
    desktopName = "Dropbox";
    genericName = "Online storage";
    categories = "Application;Internet;";
  };

in stdenv.mkDerivation {
  name = "dropbox-${version}-bin";
  src = fetchurl {
    name = "dropbox-${version}.tar.gz";
    
    url = "https://dl-web.dropbox.com/u/17/dropbox-lnx.${arch}-${version}.tar.gz";
    inherit sha256;
  };

  sourceRoot = ".";

  patchPhase = ''
    rm -f .dropbox-dist/dropboxd
  '';

  installPhase = ''
    mkdir -p "$out/${appdir}"
    cp -r ".dropbox-dist/dropbox-lnx.${arch}-${version}"/* "$out/${appdir}/"
    mkdir -p "$out/bin"
    ln -s "$out/${appdir}/dropbox" "$out/bin/dropbox"

    patchelf --set-interpreter ${stdenv.glibc}/lib/${interpreter} \
      "$out/${appdir}/dropbox"
    
    RPATH=${ldpath}:${gcc.gcc}/lib:$out/${appdir}
    echo "updating rpaths to: $RPATH"
    find "$out/${appdir}" -type f -a -perm +0100 \
      -print -exec patchelf --force-rpath --set-rpath "$RPATH" {} \;

    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications
  '';

  meta = {
    homepage = "http://www.dropbox.com";
    description = "Online stored folders (daemon version)";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
