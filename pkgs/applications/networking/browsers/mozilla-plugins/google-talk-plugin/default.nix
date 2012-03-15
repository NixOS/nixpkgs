{ stdenv, fetchurl, rpm, cpio, pkgsi686Linux, mesa, xorg, cairo
, libpng, gtk, glib, fontconfig, freetype, curl
}:

with stdenv.lib;

let

  rpathNative = makeLibraryPath
    [ stdenv.gcc.gcc
      mesa
      xorg.libXt
      xorg.libX11
      cairo
      libpng
      gtk
      glib
      fontconfig
      freetype
      curl
    ];

  rpath32 = makeLibraryPath
    [ pkgsi686Linux.gdk_pixbuf
      pkgsi686Linux.glib
      pkgsi686Linux.gtk
      pkgsi686Linux.xorg.libX11
      pkgsi686Linux.xorg.libXcomposite
      pkgsi686Linux.xorg.libXfixes
      pkgsi686Linux.xorg.libXrender
      pkgsi686Linux.xorg.libXrandr
      pkgsi686Linux.gcc.gcc
      pkgsi686Linux.alsaLib
      pkgsi686Linux.pulseaudio
      pkgsi686Linux.dbus_glib
      pkgsi686Linux.udev
    ];

in

stdenv.mkDerivation {
  name = "google-talk-plugin-2.107.0";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://dl.google.com/linux/direct/google-talkplugin_current_x86_64.rpm";
        sha256 = "1jdcnz4iwnjmrr5xyqgam1yd0dc2vyd9iij5imnir4r88l5fc9wh";
      }
    else
      throw "Google Talk does not support your platform.";

  buildInputs = [ rpm cpio ];
      
  unpackPhase =
    ''
      rpm2cpio $src | cpio -i --make-directories -v
    '';

  installPhase =
    ''
      mkdir -p $out/lib/mozilla/plugins
      cp opt/google/talkplugin/libnp*.so $out/lib/mozilla/plugins/

      patchelf --set-rpath "${makeLibraryPath [ stdenv.gcc.gcc ]}:${stdenv.gcc.gcc}/lib64" \
        $out/lib/mozilla/plugins/libnpgoogletalk64.so

      patchelf --set-rpath "$out/libexec/google/talkplugin/lib:${rpathNative}:${stdenv.gcc.gcc}/lib64" \
        $out/lib/mozilla/plugins/libnpgtpo3dautoplugin.so

      mkdir -p $out/libexec/google/talkplugin
      cp opt/google/talkplugin/GoogleTalkPlugin $out/libexec/google/talkplugin/
      
      mkdir -p $out/libexec/google/talkplugin/lib
      cp opt/google/talkplugin/lib/libCg* $out/libexec/google/talkplugin/lib/

      patchelf \
        --set-interpreter ${pkgsi686Linux.glibc}/lib/ld-linux*.so.2 \
        --set-rpath ${rpath32} \
        $out/libexec/google/talkplugin/GoogleTalkPlugin
    '';

  dontStrip = true;
  dontPatchELF = true;
  
  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    homepage = http://www.google.com/chat/video/;
    license = "unfree";
  };
}
