{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapGAppsHook4,
  python3Packages,
  cpio,
  cups,
  cyrus_sasl,
  gdk-pixbuf,
  glib,
  glib-networking,
  gst_all_1,
  gtk4,
  libfido2,
  libunwind,
  libva,
  libvdpau,
  lz4,
  pcsclite,
  protobufc,
}:
let
  pname = "nice-dcv-client";
  version = "2024.0.8004-1";
in
stdenv.mkDerivation {
  inherit version pname;

  src = fetchurl {
    url = "https://d1uj6qtbmh3dt5.cloudfront.net/${lib.versions.majorMinor version}/Clients/nice-dcv-viewer-${version}.el9.x86_64.rpm";
    sha256 = "sha256-bFe+qkNJkTHgNPThwLi7/jGQKn0kPULg1Bqtd69i/sM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook4
    python3Packages.rpm
  ];

  unpackPhase = ''
    rpm2cpio $src | ${cpio}/bin/cpio -idm
  '';

  buildInputs = [
    cups
    cyrus_sasl
    gdk-pixbuf
    gtk4
    libfido2
    libunwind
    libva
    libvdpau
    lz4
    pcsclite
    protobufc
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  installPhase =
    let
      gst_plugin_system_path = lib.makeSearchPath "lib/gstreamer-1.0/" (
        with gst_all_1;
        [
          gstreamer
          gst-plugins-base
          gst-plugins-good
        ]
      );
    in
    ''
      mkdir -p $out/bin/
      mv usr/bin/dcvviewer $out/bin/dcvviewer

      mkdir -p $out/libexec/dcvviewer
      mv \
        usr/libexec/dcvviewer/dcvextensionswatchdog \
        usr/libexec/dcvviewer/dcvviewer \
        $out/libexec/dcvviewer
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/libexec/dcvviewer/dcvviewer

      mkdir -p $out/lib64/dcvviewer
      mv \
        ./usr/lib64/dcvviewer/libavcodec.so.61 \
        ./usr/lib64/dcvviewer/libavutil.so.59 \
        ./usr/lib64/dcvviewer/libdcv.so \
        ./usr/lib64/dcvviewer/libsoup-3.0.so.0 \
        $out/lib64/dcvviewer

      mv usr/share $out/
      rm -rf $out/usr/share/doc

      ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas

      # Fix the wrapper script paths.
      sed -i \
        -e "s#\(basedir\)=/usr#\1=$out#" \
        -e "s#\(export GIO_EXTRA_MODULES\)=.*#\1=${glib-networking}/lib/gio/modules#" \
        -e "s#\(export GST_PLUGIN_SCANNER\)=.*#\1=${gst_all_1.gstreamer.out}/libexec/gstreamer-1.0/gst-plugin-scanner#" \
        -e "s#\(export GST_PLUGIN_SYSTEM_PATH\)=.*#\1=${gst_plugin_system_path}#" \
        -e "s#\(export DCV_SASL_PLUGIN_DIR\)=.*#\1=${cyrus_sasl.out}/lib/sasl2#" \
        $out/bin/dcvviewer
    '';

  meta = with lib; {
    description = "High-performance remote display protocol";
    homepage = "https://aws.amazon.com/hpc/dcv/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      rmcgibbo
      jhol
    ];
  };
}
