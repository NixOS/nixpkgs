{ stdenv, fetchurl, libGL, xorg, cairo
, libpng, gtk2, glib, gdk-pixbuf, fontconfig, freetype, curl
, dbus-glib, alsaLib, libpulseaudio, systemd, pango
}:

with stdenv.lib;

let

  baseURL = "http://dl.google.com/linux/talkplugin/deb/pool/main/g/google-talkplugin";

  rpathPlugin = makeLibraryPath
    [ libGL
      xorg.libXt
      xorg.libX11
      xorg.libXrender
      cairo
      libpng
      gtk2
      glib
      fontconfig
      freetype
      curl
    ];

  rpathProgram = makeLibraryPath
    [ gdk-pixbuf
      glib
      gtk2
      xorg.libX11
      xorg.libXcomposite
      xorg.libXfixes
      xorg.libXrender
      xorg.libXrandr
      xorg.libXext
      stdenv.cc.cc
      alsaLib
      libpulseaudio
      dbus-glib
      systemd
      curl
      pango
      cairo
    ];

in

stdenv.mkDerivation rec {
  pname = "google-talk-plugin";

  # You can get the upstream version and SHA-256 hash from the following URLs:
  # curl -s http://dl.google.com/linux/talkplugin/deb/dists/stable/main/binary-amd64/Packages | grep -E 'Version|SHA256'
  # curl -s http://dl.google.com/linux/talkplugin/deb/dists/stable/main/binary-i386/Packages | grep -E 'Version|SHA256'
  version = "5.41.3.0";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "${baseURL}/google-talkplugin_${version}-1_amd64.deb";
        sha256 = "af7e23d2b6215afc547f96615b99f04e0561557cc58c0c9302364b5a3840d97d";
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "${baseURL}/google-talkplugin_${version}-1_i386.deb";
        sha256 = "4c46d2b7f2018640288cd7ac49adc47e309d0beadfd979eb03030e672016b4a7";
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
        patchelf --set-rpath "${makeLibraryPath [ stdenv.cc.cc xorg.libX11 ]}:${stdenv.cc.cc.lib}/lib64" $plugins/$i
      done

      for i in libgoogletalkremoting.so libnpo1d.so; do
        patchelf --set-rpath "$out/libexec/google/talkplugin/lib:${rpathPlugin}:${stdenv.cc.cc.lib}/lib64" $plugins/$i
      done

      mkdir -p $out/libexec/google/talkplugin
      cp -prd opt/google/talkplugin/{data,GoogleTalkPlugin,locale,remoting24x24.png,windowpicker.glade} $out/libexec/google/talkplugin/

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpathProgram}:${stdenv.cc.cc.lib}/lib64" \
        $out/libexec/google/talkplugin/GoogleTalkPlugin

      # Generate an LD_PRELOAD wrapper to redirect execvp() calls to
      # /opt/../GoogleTalkPlugin.
      preload=$out/libexec/google/talkplugin/libpreload.so
      mkdir -p $(dirname $preload)
      gcc -shared ${./preload.c} -o $preload -ldl -DOUT=\"$out\" -fPIC
      echo $preload > $plugins/extra-ld-preload

      # Prevent a dependency on gcc.
      strip -S $preload
      patchELF $preload
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
