{ stdenv, fetchurl, rpm, cpio, mesa, xorg, cairo
, libpng, gtk, glib, gdk_pixbuf, fontconfig, freetype, curl
, dbus_glib, alsaLib, pulseaudio, udev, pango
}:

with stdenv.lib;

let

  baseURL = "http://dl.google.com/linux/talkplugin/deb/pool/main/g/google-talkplugin";

  rpathPlugin = makeLibraryPath
    [ mesa
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
      pango
      cairo
    ];

in

stdenv.mkDerivation rec {
  name = "google-talk-plugin-${version}";
  # Use the following to determine the current upstream version:
  # curl -s http://dl.google.com/linux/talkplugin/deb/dists/stable/main/binary-amd64/Packages | sed -nr 's/^Version: *([^ ]+)-1$/\1/p'
  version = "3.17.0.0";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "${baseURL}/google-talkplugin_${version}-1_amd64.deb";
        sha256 = "1annx2zhxgn3wl468w7sk93k4xhmnx5bbdjr0d1ar7979hvrdl1x";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "${baseURL}/google-talkplugin_${version}-1_i386.deb";
        sha256 = "13fza920vg3qig2pnlr65mzcmmy3izla95zdpa3pk28qlfij0ryc";
      }
    else throw "Google Talk does not support your platform.";

  unpackPhase = ''
    ar p "$src" data.tar.gz | tar xz
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
      cp -prd opt/google/talkplugin/{GoogleTalkPlugin,locale,windowpicker.glade} $out/libexec/google/talkplugin/

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
