{ alsaLib
, fetchurl
, gcc
, glib
, gst_plugins_base
, gstreamer
, icu_54_1
, libpulseaudio
, libuuid
, libxml2
, libxslt
, makeQtWrapper
, qt55
, sqlite
, stdenv
, xlibs
, xorg
, zlib
}:

stdenv.mkDerivation rec {
    name = "zoom-us";
    meta = {
      homepage = http://zoom.us;
      description = "zoom.us instant messenger";
      license = stdenv.lib.licenses.unfree;
      platforms = stdenv.lib.platforms.linux;
    };

    version = "2.0.52458.0531";
    src = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_${version}_x86_64.tar.xz";
      sha256 = "16d64pn9j27v3fnh4c9i32vpkr10q1yr26w14964n0af1mv5jf7a";
    };

    phases = [ "unpackPhase" "installPhase" ];
    nativeBuildInputs = [ makeQtWrapper ];
    libPath = stdenv.lib.makeLibraryPath [
      alsaLib
      gcc.cc
      glib
      gst_plugins_base
      gstreamer
      icu_54_1
      libpulseaudio
      libuuid
      libxml2
      libxslt
      qt55.qtbase
      qt55.qtdeclarative
      qt55.qtscript
      qt55.qtwebkit
      sqlite
      xlibs.xcbutilkeysyms
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXext
      xorg.libXfixes
      xorg.libXrender
      xorg.xcbutilimage
      zlib
    ];
    installPhase = ''
      mkdir -p $out/share
      cp -r \
         application-x-zoom.png \
         audio \
         imageformats \
         chrome.bmp \
         config-dump.sh \
         dingdong1.pcm \
         dingdong.pcm \
         doc \
         Droplet.pcm \
         Droplet.wav \
         platforminputcontexts \
         platforms \
         platformthemes \
         Qt \
         QtMultimedia \
         QtQml \
         QtQuick \
         QtQuick.2 \
         QtWebKit \
         QtWebProcess \
         ring.pcm \
         ring.wav \
         version.txt \
         xcbglintegrations \
         zcacert.pem \
         zoom \
         Zoom.png \
         ZXMPPROOT.cer \
         $out/share

      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath ${libPath} \
        $out/share/zoom
      wrapQtProgram "$out/share/zoom"
      mkdir -p $out/bin
      ln -s $out/share/zoom $out/bin/zoom-us
    '';
 }
