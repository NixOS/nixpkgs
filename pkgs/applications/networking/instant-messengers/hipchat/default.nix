{ stdenv, fetchurl, libtool, xlibs, freetype, fontconfig, openssl, glib
, mesa, gstreamer, gst_plugins_base, dbus, alsaLib, zlib, libuuid
, libxml2, libxslt, sqlite, libogg, libvorbis, xz, libcanberra, makeWrapper }:

let

  version = "2.2.1107";

  rpath = stdenv.lib.makeSearchPath "lib" [
    stdenv.glibc
    libtool
    xlibs.libXext
    xlibs.libSM
    xlibs.libICE
    xlibs.libX11
    xlibs.libXft
    xlibs.libXau
    xlibs.libXdmcp
    xlibs.libXrender
    xlibs.libXfixes
    xlibs.libXcomposite
    xlibs.libxcb
    xlibs.libXi
    freetype
    fontconfig
    openssl
    glib
    mesa
    gstreamer
    gst_plugins_base
    dbus
    alsaLib
    zlib
    libuuid
    libxml2
    libxslt
    sqlite
    libogg
    libvorbis
    xz
    libcanberra
  ] + ":${stdenv.gcc.gcc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://downloads.hipchat.com/linux/arch/x86_64/hipchat-${version}-x86_64.pkg.tar.xz";
        sha256 = "0lf780pxbh40m2i48cki072lrm75924cz3zgkmaxddmar3y13bwa";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://downloads.hipchat.com/linux/arch/i686/hipchat-${version}-i686.pkg.tar.xz";
        sha256 = "1k33670rpigdpy9jcacryc1i05ykp5yffcplmbm5q29ng54cn0zv";
      }
    else
      throw "HipChat is not supported on ${stdenv.system}";

in

stdenv.mkDerivation {
  name = "hipchat-${version}";

  inherit src;

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    tar xf ${src}

    d=$out/libexec/hipchat
    mkdir -p $out/libexec
    rm -rfv opt/HipChat/lib/{libstdc++*,libz*,libuuid*,libxml2*,libxslt*,libsqlite*,libogg*,libvorbis*,liblzma*,libcanberra.*,libcanberra-*}
    mv opt/HipChat/lib/ $d
    mv usr/share $out

    patchShebangs $out/bin

    for file in $(find $d -type f); do
        patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $file || true
        patchelf --set-rpath ${rpath}:\$ORIGIN $file || true
    done

    substituteInPlace $out/share/applications/hipchat.desktop \
      --replace /opt/HipChat/bin $out/bin

    makeWrapper $d/hipchat.bin $out/bin/hipchat \
      --set HIPCHAT_LD_LIBRARY_PATH '"$LD_LIBRARY_PATH"' \
      --set HIPCHAT_QT_PLUGIN_PATH '"$QT_PLUGIN_PATH"'

    mv opt/HipChat/bin/linuxbrowserlaunch $out/bin
  '';

  meta = {
    description = "HipChat Desktop Client";
    homepage = http://www.hipchat.com;
    license = stdenv.lib.licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
