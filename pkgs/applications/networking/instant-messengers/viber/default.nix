{fetchurl, stdenv, dpkg, makeWrapper,
 alsaLib, cups, curl, dbus, expat, fontconfig, freetype, glib, gst_all_1, harfbuzz, libcap,
 libpulseaudio, mesa, nspr, nss, systemd, wayland, xorg, zlib, ...
}:

assert stdenv.system == "x86_64-linux";

# BUG: Viber requires running tray application, segfaulting if it's missing
# FIX: Start something like `stalonetray` if you DE doesn't provide tray

stdenv.mkDerivation rec {
  name = "viber-${version}";
  version = "6.0.1.5";

  src = fetchurl {
    url = "http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
    sha256 = "026vp2pv66b2dlwi5w5wk4yjnnmnsqapdww98p7xdnz8n0hnsbbi";
  };

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  libPath = stdenv.lib.makeLibraryPath [
      alsaLib
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      glib
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      harfbuzz
      libcap
      libpulseaudio
      mesa
      nspr
      nss
      stdenv.cc.cc
      systemd
      wayland
      zlib

      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXtst
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
  ]
  ;

  installPhase = ''
    dpkg-deb -x $src $out
    mkdir -p $out/bin

    # Soothe nix-build "suspicions"
    chmod -R g-w $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath $libPath:$out/opt/viber/lib $file || true
    done

    # qt.conf is not working, so override everything using environment variables
    wrapProgram $out/opt/viber/Viber \
      --set QT_PLUGIN_PATH "$out/opt/viber/plugins" \
      --set QT_XKB_CONFIG_ROOT "${xorg.xkeyboardconfig}/share/X11/xkb" \
      --set QTCOMPOSE "${xorg.libX11.out}/share/X11/locale"
    ln -s $out/opt/viber/Viber $out/bin/viber

    mv $out/usr/share $out/share
    rm -rf $out/usr

    # Fix the desktop link
    substituteInPlace $out/share/applications/viber.desktop \
      --replace /opt/viber/Viber $out/opt/viber/Viber \
      --replace /usr/share/ $out/share/
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = http://www.viber.com;
    description = "An instant messaging and Voice over IP (VoIP) app";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jagajaga ];
  };

}
