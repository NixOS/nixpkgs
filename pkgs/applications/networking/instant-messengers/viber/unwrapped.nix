{ lib
, fetchurl
, makeBinaryWrapper
, autoPatchelfHook
, dpkg
, alsa-lib
, nss
, gst_all_1
, stdenvNoCC
, xorg
, lcms
, libwebp
, snappy
, gdk-pixbuf
, libmng
, gtk3
, pango
, libtiff
, tslib
, mtdev
, libxslt
, libpulseaudio
, mesa
, xcb-util-cursor
, libxkbcommon
, libglvnd
, brotli
, cups
, libevent
, fontconfig
, freetype
, libkrb5
, harfbuzz
, nspr
, zstd
, udev
}:

stdenvNoCC.mkDerivation {
  pname = "viber";
  version = "21.0.0.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20231030150355/https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
    hash = "sha256-47E6emeIYyG0jid7Oqrn2CEKtb9nQhOckFtEMBevZGA=";
  };

  # Needed due to failing libudev dlopen.
  appendRunpaths = [
    "${udev}/lib"
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = [
    alsa-lib
    brotli.lib
    cups.lib
    libevent
    fontconfig.lib
    freetype
    gtk3
    gdk-pixbuf
    libkrb5
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    harfbuzz
    xorg.libICE
    lcms
    libmng
    mtdev
    nspr
    nss
    pango
    xorg.libSM
    snappy
    libtiff
    libwebp
    xorg.xcbutilwm
    xorg.xcbutilkeysyms
    xorg.libxkbfile
    xorg.libXrandr
    libxslt
    xorg.libXScrnSaver
    xorg.libXtst
    zstd
    libxkbcommon
    libglvnd
    libpulseaudio
    mesa
    xcb-util-cursor
    tslib
  ];

  installPhase =
    let
      gstreamerPluginPath = lib.makeSearchPath "lib/gstreamer-1.0/" [
        gst_all_1.gstreamer.out
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-plugins-bad
      ];
    in
    ''
      dpkg-deb -x $src $out
      mkdir -p $out/bin

      # Soothe nix-build "suspicions"
      chmod -R g-w $out

      # GST_PLUGIN_SYSTEM_PATH is specified because Qt6's QGStreamerMediaPlayer calls
      # gst_element_factory_make which in turn uses the env variable to perform the lookup.
      # Qt6 uses the returned object without checking for NULL which will lead to a SEGFAULT.

      wrapProgram $out/opt/viber/Viber \
      --set QT_PLUGIN_PATH "$out/opt/viber/plugins" \
      --set QML2_IMPORT_PATH "$out/opt/viber/qml" \
      --prefix XDG_DATA_DIRS : "$out/share" \
      --set GST_PLUGIN_SYSTEM_PATH "${gstreamerPluginPath}"

      ln -s $out/opt/viber/Viber $out/bin/Viber

      mv $out/usr/share $out/share
      rm -rf $out/usr

      # Fix the desktop link
      substituteInPlace $out/share/applications/viber.desktop \
        --replace /opt/viber/Viber Viber \
        --replace /usr/share/ $out/share/
    '';

  preFixup = ''
    # Ugly hack, libtiff.so.5 is not in nixpkgs. Does not seem to break anything.
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/viber/plugins/imageformats/libqtiff.so
  '';

  meta = {
    homepage = "https://www.viber.com";
    description = "An instant messaging and Voice over IP (VoIP) app";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ jagajaga liarokapisv ];
  };
}
