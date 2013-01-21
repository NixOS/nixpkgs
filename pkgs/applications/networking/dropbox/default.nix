{ stdenv, fetchurl, makeDesktopItem
, libSM, libX11, libXext, libXcomposite, libXcursor, libXdamage
, libXfixes, libXi, libXinerama, libXrandr, libXrender
, dbus, dbus_glib, fontconfig, gcc, patchelf
, atk, glib, gdk_pixbuf, gtk, pango
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

# note: there is a i686 version available as well
assert stdenv.system == "x86_64-linux";

let

  version = "1.4.21";
  sha256 = "94073842f4a81feee80bca590e1df73fc3cab47ba879407ceba2de48f30d84e2";

  # relative location where the dropbox libraries are stored
  appdir = "opt/dropbox";

  # Libraries referenced by dropbox binary.
  # Be aware that future versions of the dropbox binary may refer
  # to different versions than are currently in these packages.
  ldpath = stdenv.lib.makeSearchPath "lib" [
      libSM libX11 libXext libXcomposite libXcursor libXdamage
      libXfixes libXi libXinerama libXrandr libXrender
      atk dbus dbus_glib glib fontconfig gcc gdk_pixbuf
      gtk pango
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
    # using version-specific URL so if the version is no longer available,
    # build will fail without having to finish downloading first
    # url = "http://www.dropbox.com/download?plat=lnx.x86_64";
    url = "http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${version}.tar.gz";
    inherit sha256;
  };

  sourceRoot = ".";

  patchPhase = ''
    rm -f .dropbox-dist/dropboxd
  '';

  installPhase = ''
    ensureDir "$out/${appdir}"
    cp -r .dropbox-dist/* "$out/${appdir}/"
    ensureDir "$out/bin"
    ln -s "$out/${appdir}/dropbox" "$out/bin/dropbox"

    patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
      "$out/${appdir}/dropbox"

    RPATH=${ldpath}:${gcc.gcc}/lib64:$out/${appdir}
    echo "updating rpaths to: $RPATH"
    find "$out/${appdir}" -type f -a -perm +0100 \
      -print -exec patchelf --force-rpath --set-rpath "$RPATH" {} \;

    ensureDir "$out/share/applications"
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  buildInputs = [ patchelf ];

  meta = {
    description = "Online stored folders (daemon version)";
    homepage = http://www.dropbox.com;
  };
}
