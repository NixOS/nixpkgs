{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, dbus_libs, gcc, glib, libdrm, libffi, libICE, libSM
, libX11, libXmu, ncurses, popt, qt5, zlib, mesa_noglu
}:

# this package contains the daemon version of dropbox
# it's unfortunately closed source
#
# note: the resulting program has to be invoced as
# 'dropbox' because the internal python engine takes
# uses the name of the program as starting point.

# Dropbox ships with its own copies of some libraries.
# Unfortunately, upstream makes changes to the source of
# some libraries, rendering them incompatible with the
# open-source versions. Wherever possible, we must try
# to make the bundled libraries work, rather than replacing
# them with our own.

let
  # NOTE: When updating, please also update in current stable, as older versions stop working
  version = "3.14.7";
  sha256 =
    {
      "x86_64-linux" = "1pwmghpr0kyca2biysyk90kk9k6ffv4i95vs5rq96vc0zbckws6n";
      "i686-linux" = "08yqrxh09cfd80kbiq1f2sirx9s85acij4khpklvvwrnf2x1i1zm";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  arch =
    {
      "x86_64-linux" = "x86_64";
      "i686-linux" = "x86";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  interpreter =
    {
      "x86_64-linux" = "ld-linux-x86-64.so.2";
      "i686-linux" = "ld-linux.so.2";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  # relative location where the dropbox libraries are stored
  appdir = "opt/dropbox";

  ldpath = stdenv.lib.makeSearchPath "lib"
    [
      dbus_libs gcc glib libdrm libffi libICE libSM libX11
      libXmu ncurses popt qt5.qtbase qt5.qtdeclarative qt5.qtwebkit
      zlib
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

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p "$out/${appdir}"
    cp -r ".dropbox-dist/dropbox-lnx.${arch}-${version}"/* "$out/${appdir}/"

    rm "$out/${appdir}/libdrm.so.2"
    rm "$out/${appdir}/libffi.so.6"
    rm "$out/${appdir}/libicudata.so.42"
    rm "$out/${appdir}/libicui18n.so.42"
    rm "$out/${appdir}/libicuuc.so.42"
    rm "$out/${appdir}/libGL.so.1"
    rm "$out/${appdir}/libpopt.so.0"
    rm "$out/${appdir}/libQt5Core.so.5"
    rm "$out/${appdir}/libQt5DBus.so.5"
    rm "$out/${appdir}/libQt5Gui.so.5"
    rm "$out/${appdir}/libQt5Network.so.5"
    rm "$out/${appdir}/libQt5OpenGL.so.5"
    rm "$out/${appdir}/libQt5PrintSupport.so.5"
    rm "$out/${appdir}/libQt5Qml.so.5"
    rm "$out/${appdir}/libQt5Quick.so.5"
    rm "$out/${appdir}/libQt5Sql.so.5"
    rm "$out/${appdir}/libQt5WebKit.so.5"
    rm "$out/${appdir}/libQt5WebKitWidgets.so.5"
    rm "$out/${appdir}/libQt5Widgets.so.5"
    rm "$out/${appdir}/libX11-xcb.so.1"

    rm "$out/${appdir}/qt.conf"
    rm -fr "$out/${appdir}/plugins"

    find "$out/${appdir}" -type f -a -perm -0100 \
      -print -exec patchelf --set-interpreter ${stdenv.glibc}/lib/${interpreter} {} \;

    RPATH=${ldpath}:${gcc.cc}/lib:$out/${appdir}
    echo "updating rpaths to: $RPATH"
    find "$out/${appdir}" -type f -a -perm -0100 \
      -print -exec patchelf --force-rpath --set-rpath "$RPATH" {} \;

    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications

    mkdir -p "$out/bin"
    makeWrapper "$out/${appdir}/dropbox" "$out/bin/dropbox" \
      --prefix LD_LIBRARY_PATH : "${ldpath}" \
      --suffix LD_LIBRARY_PATH : "${mesa_noglu}/lib"

    mkdir -p "$out/share/icons"
    ln -s "$out/${appdir}/images/hicolor" "$out/share/icons/hicolor"
  '';

  meta = {
    homepage = "http://www.dropbox.com";
    description = "Online stored folders (daemon version)";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
