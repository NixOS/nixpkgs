{fetchurl, lib, stdenv, dpkg, makeWrapper,
 alsa-lib, cups, curl, dbus, expat, fontconfig, freetype, glib, gst_all_1,
 harfbuzz, libcap, libGL, libGLU, libpulseaudio, libxkbcommon, libxml2, libxslt,
 nspr, nss, openssl_1_1, systemd, wayland, xorg, zlib, ...
}:

stdenv.mkDerivation {
  pname = "viber";
  version = "16.1.0.37";

  src = fetchurl {
    # Official link: https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
    url = "https://web.archive.org/web/20211119123858/https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
    sha256 = "sha256-hOz+EQc2OOlLTPa2kOefPJMUyWvSvrgqgPgBKjWE3p8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ dpkg ];

  dontUnpack = true;

  libPath = lib.makeLibraryPath [
      alsa-lib
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
      libGLU libGL
      libpulseaudio
      libxkbcommon
      libxml2
      libxslt
      nspr
      nss
      openssl_1_1
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
      --set QTCOMPOSE "${xorg.libX11.out}/share/X11/locale" \
      --set QML2_IMPORT_PATH "$out/opt/viber/qml"
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
    homepage = "https://www.viber.com";
    description = "An instant messaging and Voice over IP (VoIP) app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ jagajaga ];
  };

}
