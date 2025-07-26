{
  autoPatchelfHook,
  cairo,
  cups,
  cyrus_sasl,
  dpkg,
  fetchurl,
  ffmpeg,
  gdk-pixbuf,
  glib,
  glibc,
  glib-networking,
  gst_all_1,
  gtk4,
  icu74,
  jbigkit,
  lib,
  libepoxy,
  libfido2,
  libgcc,
  libgudev,
  libjpeg,
  libpng,
  libproxy,
  libpulseaudio,
  librsvg,
  libsoup_3,
  libva,
  libvdpau,
  lz4,
  openssl,
  pango,
  pcsclite,
  protobufc,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "nice-dcv-client";
  version = "2024.0.8004-1";
  src = fetchurl {
    url = "https://d1uj6qtbmh3dt5.cloudfront.net/2024.0/Clients/nice-dcv-viewer_${version}_amd64.ubuntu2404.deb";
    sha256 = "sha256-yCVbwh1C3sq5sSv9JEMCG9J3NOipdZFutmrA3Jn7fps=";
  };

  postPhases = [ "finalPhase" ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    cups
    cyrus_sasl
    ffmpeg.lib
    gdk-pixbuf
    glib
    glibc
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gtk4
    icu74
    jbigkit
    libepoxy
    libfido2
    libgcc.lib
    libgudev
    libjpeg
    libpng
    libproxy
    libpulseaudio
    librsvg
    libsoup_3
    libva
    libvdpau
    lz4.lib
    openssl
    pango
    pcsclite
    protobufc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share $out/share
    cp -r usr/bin $out/bin

    mkdir -p $out/lib/x86_64-linux-gnu/dcvviewer
    cp usr/lib/x86_64-linux-gnu/dcvviewer/dcvviewer $out/lib/x86_64-linux-gnu/dcvviewer
    cp usr/lib/x86_64-linux-gnu/dcvviewer/libdcv.so $out/lib/x86_64-linux-gnu/dcvviewer

    mkdir -p $out/lib/x86_64-linux-gnu/dcvviewer/gio/modules
    cp usr/lib/x86_64-linux-gnu/dcvviewer/gio/modules/libgioopenssl.so $out/lib/x86_64-linux-gnu/dcvviewer/gio/modules

    mkdir -p $out/lib/x86_64-linux-gnu/dcvviewer/gdk-pixbuf-2.0/2.10.0
    cp -r usr/lib/x86_64-linux-gnu/dcvviewer/gdk-pixbuf-2.0/2.10.0/loaders $out/lib/x86_64-linux-gnu/dcvviewer/gdk-pixbuf-2.0/2.10.0

    # Fix the wrapper script to have the right basedir.
    sed -i "s#basedir=/usr#basedir=$out#" $out/bin/dcvviewer

    # Remove all the extra env vars that we'll be patching in
    sed -i "/export GIO_EXTRA_MODULES/d" $out/bin/dcvviewer
    sed -i "/export GST_PLUGIN_SYSTEM_PATH/d" $out/bin/dcvviewer
    sed -i "/export GST_PLUGIN_SCANNER/d" $out/bin/dcvviewer
    sed -i "/export DCV_SASL_PLUGIN_DIR/d" $out/bin/dcvviewer
    sed -i "/export GTK_PATH/d" $out/bin/dcvviewer
    sed -i "/export PANGO_LIBDIR/d" $out/bin/dcvviewer

    gtk4-update-icon-cache -t $out/share/icons/hicolor
    glib-compile-schemas $out/share/glib-2.0/schemas
    glib-compile-schemas $out/share/dcvviewer/schemas

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GIO_EXTRA_MODULES : "$out/lib/x86_64-linux-gnu/dcvviewer/gio/modules"
      --prefix DCV_SASL_PLUGIN_DIR : "${lib.getLib cyrus_sasl}/lib/sasl2"
      --prefix PANGO_LIBDIR : "${lib.getLib pango}/lib"
    )
  '';

  finalPhase = ''
    gdk-pixbuf-query-loaders $out/lib/x86_64-linux-gnu/dcvviewer/gdk-pixbuf-2.0/2.10.0/loaders/*.so > $out/lib/x86_64-linux-gnu/dcvviewer/gdk-pixbuf-2.0/2.10.0/loaders.cache
  '';

  meta = with lib; {
    description = "High-performance remote display protocol";
    homepage = "https://aws.amazon.com/hpc/dcv/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
