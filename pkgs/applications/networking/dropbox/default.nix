{ stdenv, fetchurl, makeDesktopItem, patchelf, makeWrapper
, dbus_libs, fontconfig, freetype, gcc, glib
, libdrm, libffi, libICE, libSM
, libX11, libXcomposite, libXext, libXmu, libXrender, libxcb
, libxml2, libxslt, ncurses, zlib
, qtbase, qtdeclarative, qtwebkit
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
  # NOTE: When updating, please also update in current stable,
  # as older versions stop working
  version = "9.4.49";
  sha256 =
    {
      "x86_64-linux" = "0gkm4jhcn3pqaizmki98rbqb7mqyf6mjgmpslas1wr94q5msyrpd";
      "i686-linux"   = "08h5jxan6l9h4zfmvc5q2652dyplih2avayy8f9h8mppirpg68px";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  arch =
    {
      "x86_64-linux" = "x86_64";
      "i686-linux"   = "x86";
    }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  # relative location where the dropbox libraries are stored
  appdir = "opt/dropbox";

  ldpath = stdenv.lib.makeLibraryPath
    [
      dbus_libs fontconfig freetype gcc.cc glib libdrm libffi libICE libSM
      libX11 libXcomposite libXext libXmu libXrender libxcb libxml2 libxslt
      ncurses zlib

      qtbase qtdeclarative qtwebkit
    ];

  desktopItem = makeDesktopItem {
    name = "dropbox";
    exec = "dropbox";
    comment = "Sync your files across computers and to the web";
    desktopName = "Dropbox";
    genericName = "File Synchronizer";
    categories = "Network;FileTransfer;";
    startupNotify = "false";
  };

in stdenv.mkDerivation {
  name = "dropbox-${version}";
  src = fetchurl {
    name = "dropbox-${version}.tar.gz";
    url = "https://dl-web.dropbox.com/u/17/dropbox-lnx.${arch}-${version}.tar.gz";
    inherit sha256;
  };

  sourceRoot = ".dropbox-dist";

  nativeBuildInputs = [ makeWrapper patchelf ];
  dontPatchELF = true; # patchelf invoked explicitly below
  dontStrip = true; # already done

  installPhase = ''
    mkdir -p "$out/${appdir}"
    cp -r --no-preserve=mode "dropbox-lnx.${arch}-${version}"/* "$out/${appdir}/"

    rm "$out/${appdir}/libdrm.so.2"
    rm "$out/${appdir}/libffi.so.6"
    rm "$out/${appdir}/libGL.so.1"
    rm "$out/${appdir}/libX11-xcb.so.1"

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
    rm "$out/${appdir}/libQt5XcbQpa.so.5"

    mkdir -p "$out/share/applications"
    cp "${desktopItem}/share/applications/"* $out/share/applications

    mkdir -p "$out/share/icons"
    ln -s "$out/${appdir}/images/hicolor" "$out/share/icons/hicolor"

    mkdir -p "$out/bin"
    RPATH="${ldpath}:$out/${appdir}"
    makeWrapper "$out/${appdir}/dropbox" "$out/bin/dropbox" \
      --prefix LD_LIBRARY_PATH : "$RPATH"

    chmod 755 $out/${appdir}/dropbox
  '';

  fixupPhase = ''
    INTERP=$(cat $NIX_CC/nix-support/dynamic-linker)
    RPATH="${ldpath}:$out/${appdir}"
    getType='s/ *Type: *\([A-Z]*\) (.*/\1/'
    find "$out/${appdir}" -type f -a -perm -0100 -print | while read obj; do
        dynamic=$(readelf -S "$obj" 2>/dev/null | grep "DYNAMIC" || true)

        if [[ -n "$dynamic" ]]; then
            type=$(readelf -h "$obj" 2>/dev/null | grep 'Type:' | sed -e "$getType")

            if [[ "$type" == "EXEC" ]]; then

                echo "patching interpreter path in $type $obj"
                patchelf --set-interpreter "$INTERP" "$obj"

                echo "patching RPATH in $type $obj"
                oldRPATH=$(patchelf --print-rpath "$obj")
                patchelf --set-rpath "''${oldRPATH:+$oldRPATH:}$RPATH" "$obj"

                echo "shrinking RPATH in $type $obj"
                patchelf --shrink-rpath "$obj"

            elif [[ "$type" == "DYN" ]]; then

                echo "patching RPATH in $type $obj"
                oldRPATH=$(patchelf --print-rpath "$obj")
                patchelf --set-rpath "''${oldRPATH:+$oldRPATH:}$RPATH" "$obj"

                echo "shrinking RPATH in $type $obj"
                patchelf --shrink-rpath "$obj"

            else

                echo "unknown ELF type \"$type\"; not patching $obj"

            fi
        fi
    done
  '';

  meta = {
    homepage = "http://www.dropbox.com";
    description = "Online stored folders (daemon version)";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = stdenv.lib.licenses.unfree;
  };
}
