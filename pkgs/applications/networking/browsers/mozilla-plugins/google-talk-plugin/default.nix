{ stdenv, fetchurl, rpm, cpio, mesa, xorg, cairo
, libpng12, gtk, glib, gdk_pixbuf, fontconfig, freetype, curl
, dbus_glib, alsaLib, pulseaudio, udev
}:

with stdenv.lib;

let

  rpathPlugin = makeLibraryPath
    [ mesa
      xorg.libXt
      xorg.libX11
      cairo
      libpng12
      gtk
      glib
      fontconfig
      freetype
      curl
    ];

  rpathProgram = makeLibraryPath
    [ gdk_pixbuf
      glib
      gtk
      xorg.libX11
      xorg.libXcomposite
      xorg.libXfixes
      xorg.libXrender
      xorg.libXrandr
      stdenv.gcc.gcc
      alsaLib
      pulseaudio
      dbus_glib
      udev
      curl
    ];

in

stdenv.mkDerivation {
  name = "google-talk-plugin-2.8.5.0";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://dl.google.com/linux/direct/google-talkplugin_current_x86_64.rpm";
        sha256 = "15909wnhspjci0fspvh5j87v1xl7dfix36zrpvk6fpc3m0vys0nh";
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
      plugins=$out/lib/mozilla/plugins
      mkdir -p $plugins
      cp opt/google/talkplugin/libnp*.so $plugins

      patchelf --set-rpath "${makeLibraryPath [ stdenv.gcc.gcc xorg.libX11 ]}:${stdenv.gcc.gcc}/lib64" \
        $plugins/libnpgoogletalk.so

      patchelf --set-rpath "$out/libexec/google/talkplugin/lib:${rpathPlugin}:${stdenv.gcc.gcc}/lib64" \
        $plugins/libnpgtpo3dautoplugin.so

      mkdir -p $out/libexec/google/talkplugin
      cp opt/google/talkplugin/GoogleTalkPlugin $out/libexec/google/talkplugin/
      
      mkdir -p $out/libexec/google/talkplugin/lib
      cp opt/google/talkplugin/lib/libCg* $out/libexec/google/talkplugin/lib/

      patchelf --set-rpath "$out/libexec/google/talkplugin/lib" \
        $out/libexec/google/talkplugin/lib/libCgGL.so 

      patchelf \
        --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
        --set-rpath "${rpathProgram}:${stdenv.gcc.gcc}/lib64" \
        $out/libexec/google/talkplugin/GoogleTalkPlugin

      # Generate an LD_PRELOAD wrapper to redirect execvp() calls to
      # /opt/../GoogleTalkPlugin.
      preload=$out/libexec/google/talkplugin/libpreload.so
      mkdir -p $(dirname $preload)
      gcc -shared ${./preload.c} -o $preload -ldl -DOUT=\"$out\" -fPIC
      echo $preload > $plugins/extra-ld-preload
    '';

  dontStrip = true;
  dontPatchELF = true;
  
  passthru.mozillaPlugin = "/lib/mozilla/plugins";

  meta = {
    homepage = http://www.google.com/chat/video/;
    license = "unfree";
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
