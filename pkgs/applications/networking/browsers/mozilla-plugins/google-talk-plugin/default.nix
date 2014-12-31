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
      xorg.libXrender
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
      stdenv.cc.gcc
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

  # You can get the upstream version and SHA-1 hash from the following URLs:
  # curl -s http://dl.google.com/linux/talkplugin/deb/dists/stable/main/binary-amd64/Packages | grep -E 'Version|SHA1'
  # curl -s http://dl.google.com/linux/talkplugin/deb/dists/stable/main/binary-i386/Packages | grep -E 'Version|SHA1'
  version = "5.4.2.0";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "${baseURL}/google-talkplugin_${version}-1_amd64.deb";
        sha1 = "d75fad757750b4830c4e401ade92b4993e2a4ab2";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "${baseURL}/google-talkplugin_${version}-1_i386.deb";
        sha1 = "410872377b0bdac06b580c5e1755a3a3c712144b";
      }
    else throw "Google Talk does not support your platform.";

  unpackPhase = ''
    ar p "$src" data.tar.gz | tar xz
  '';

  installPhase =
    ''
      plugins=$out/lib/mozilla/plugins
      mkdir -p $plugins
      cp opt/google/talkplugin/*.so $plugins

      for i in libnpgoogletalk.so libppgoogletalk.so libppo1d.so; do
        patchelf --set-rpath "${makeLibraryPath [ stdenv.cc.gcc xorg.libX11 ]}:${stdenv.cc.gcc}/lib64" $plugins/$i
      done

      for i in libgoogletalkremoting.so libnpo1d.so; do
        patchelf --set-rpath "$out/libexec/google/talkplugin/lib:${rpathPlugin}:${stdenv.cc.gcc}/lib64" $plugins/$i
      done

      mkdir -p $out/libexec/google/talkplugin
      cp -prd opt/google/talkplugin/{data,GoogleTalkPlugin,locale,remoting24x24.png,windowpicker.glade} $out/libexec/google/talkplugin/

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpathProgram}:${stdenv.cc.gcc}/lib64" \
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
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
