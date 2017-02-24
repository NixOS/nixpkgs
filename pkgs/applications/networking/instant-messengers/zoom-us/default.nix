{ alsaLib
, fetchurl
, gcc
, glib
, gst_plugins_base
, gstreamer
, icu
, libpulseaudio
, libuuid
, libxml2
, libxslt
, makeQtWrapper
, qt56
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

    version = "2.0.81497.0116";
    src = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "1lq59l5vxirjgcsrl6r4nqgvjr519gkn69alffv1f1fwq5vzif7j";
    };

    phases = [ "unpackPhase" "installPhase" ];
    nativeBuildInputs = [ makeQtWrapper ];
    buildInputs = [
      alsaLib
      gcc.cc
      glib
      gst_plugins_base
      gstreamer
      icu
      libpulseaudio
      libuuid
      libxml2
      libxslt
      qt56.qtbase
      qt56.qtdeclarative
      qt56.qtlocation
      qt56.qtscript
      qt56.qtwebchannel
      qt56.qtwebengine
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

    libPath = stdenv.lib.makeLibraryPath buildInputs;

    installPhase = ''
      mkdir -p $out/share
      cp -r \
         application-x-zoom.png \
         audio \
         imageformats \
         config-dump.sh \
         dingdong1.pcm \
         dingdong.pcm \
         doc \
         Droplet.pcm \
         Droplet.wav \
         platforminputcontexts \
         platforms \
         platformthemes \
         leave.pcm \
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
      paxmark m $out/share/zoom
      wrapQtProgram "$out/share/zoom"
      mkdir -p $out/bin
      ln -s $out/share/zoom $out/bin/zoom-us
    '';
 }
