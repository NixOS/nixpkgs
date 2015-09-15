{ stdenv, fetchurl, libtool, xorg, freetype, fontconfig, openssl, glib
, mesa, gstreamer, gst_plugins_base, dbus, alsaLib, zlib, libuuid
, libxml2, libxslt, sqlite, libogg, libvorbis, xz, libcanberra
, makeWrapper, libredirect, xkeyboard_config, xcbutilkeysyms }:

let

  version = "2.2.1373";

  rpath = stdenv.lib.makeSearchPath "lib" [
    stdenv.glibc
    libtool
    xorg.libXext
    xorg.libSM
    xorg.libICE
    xorg.libX11
    xorg.libXft
    xorg.libXau
    xorg.libXdmcp
    xorg.libXrender
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libxcb
    xorg.libXi
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
    xcbutilkeysyms
  ] + ":${stdenv.cc.cc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://downloads.hipchat.com/linux/arch/x86_64/hipchat-${version}-x86_64.pkg.tar.xz";
        sha256 = "0mxjzigncp8sh5w2rpr7kvkiahagm3adss1zv6rqk8hc1awrnd8n";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "http://downloads.hipchat.com/linux/arch/i686/hipchat-${version}-i686.pkg.tar.xz";
        sha256 = "1f4cjbazgifxpyr6589frs417h4wpxbykf46w5qiw0m2wiqpqff5";
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

    mkdir -p $out/libexec/hipchat/bin
    d=$out/libexec/hipchat/lib
    rm -rfv opt/HipChat/lib/{libstdc++*,libz*,libuuid*,libxml2*,libxslt*,libsqlite*,libogg*,libvorbis*,liblzma*,libcanberra.*,libcanberra-*}
    mv opt/HipChat/lib/ $d
    mv usr/share $out

    for file in $(find $d -type f); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $file || true
        patchelf --set-rpath ${rpath}:\$ORIGIN $file || true
    done

    substituteInPlace $out/share/applications/hipchat.desktop \
      --replace /opt/HipChat/bin $out/bin

    makeWrapper $d/hipchat.bin $out/bin/hipchat \
      --set HIPCHAT_LD_LIBRARY_PATH '"$LD_LIBRARY_PATH"' \
      --set HIPCHAT_QT_PLUGIN_PATH '"$QT_PLUGIN_PATH"' \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /usr/share/X11/xkb=${xkeyboard_config}/share/X11/xkb

    mv opt/HipChat/bin/linuxbrowserlaunch $out/libexec/hipchat/bin/
  '';

  meta = with stdenv.lib; {
    description = "Desktop client for HipChat services";
    homepage = http://www.hipchat.com;
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ jgeerds ];
  };
}
