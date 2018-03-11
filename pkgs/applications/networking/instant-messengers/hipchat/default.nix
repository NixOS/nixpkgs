{ stdenv, fetchurl, xorg, freetype, fontconfig, openssl, glib, nss, nspr, expat
, alsaLib, dbus, zlib, libxml2, libxslt, makeWrapper, xkeyboard_config, systemd
, libGL, xcbutilkeysyms, xdg_utils, libtool }:

let

  version = "4.30.3.1670";

  rpath = stdenv.lib.makeLibraryPath [
    xdg_utils
    xorg.libXext
    xorg.libSM
    xorg.libICE
    xorg.libX11
    xorg.libXrandr
    xorg.libXdamage
    xorg.libXrender
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libxcb
    xorg.libXi
    xorg.libXScrnSaver
    xorg.libXtst
    freetype
    fontconfig
    openssl
    glib
    nss
    nspr
    dbus
    alsaLib
    zlib
    libtool
    libxml2
    libxslt
    expat
    xcbutilkeysyms
    systemd
    libGL
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client/pool/HipChat4-${version}-Linux.deb";
        sha256 = "0alqzay6bvi7ybrrdk5r0xkg4sx6qjsqbgmr16bkqxncxhb215ay";
      }
    else
      throw "HipChat is not supported on ${stdenv.system}";

in

stdenv.mkDerivation {
  name = "hipchat-${version}";

  inherit src;

  buildInputs = [ makeWrapper ];

  buildCommand = ''
    ar x $src
    tar xfvz data.tar.gz

    mkdir -p $out/libexec/hipchat
    d=$out/libexec/hipchat/lib
    mv opt/HipChat4/* $out/libexec/hipchat/
    mv usr/share $out

    for file in $(find $d -type f); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $file || true
        patchelf --set-rpath ${rpath}:$out/libexec/hipchat/lib:\$ORIGIN $file || true
    done

    patchShebangs $d/linuxbrowserlaunch.sh

    substituteInPlace $out/share/applications/hipchat4.desktop \
      --replace /opt/HipChat4/bin/HipChat4 $out/bin/hipchat

    makeWrapper $d/HipChat.bin $out/bin/hipchat \
      --run 'export HIPCHAT_LD_LIBRARY_PATH=$LD_LIBRARY_PATH' \
      --run 'export HIPCHAT_QT_PLUGIN_PATH=$QT_PLUGIN_PATH' \
      --set QT_XKB_CONFIG_ROOT ${xkeyboard_config}/share/X11/xkb \
      --set QTWEBENGINEPROCESS_PATH $d/QtWebEngineProcess

    makeWrapper $d/QtWebEngineProcess.bin $d/QtWebEngineProcess \
      --set QT_PLUGIN_PATH "$d/plugins"
  '';

  meta = with stdenv.lib; {
    description = "Desktop client for HipChat services";
    homepage = http://www.hipchat.com;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jgeerds puffnfresh ];
  };
}
