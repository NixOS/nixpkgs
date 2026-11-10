{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  replaceVars,
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
  libadwaita,
  libfido2,
  libproxy,
  libva,
  lz4,
  pcsclite,
  protobufc,
}:
let
  pname = "nice-dcv-client";
  version = "2026.0.14555-1";
in
stdenv.mkDerivation {
  inherit version pname;

  src = fetchurl {
    url = "https://d1uj6qtbmh3dt5.cloudfront.net/${lib.versions.majorMinor version}/Clients/nice-dcv-viewer-${version}.el9.x86_64.rpm";
    sha256 = "sha256-r9FNZEa2fIQjcJdMFm7XDLgBh3kEbLktw4blZl4Syvk=";
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
    libadwaita
    libfido2
    libproxy
    libva
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
      fixPathsPatch = replaceVars ./fix-paths.patch {
        basedir = null;
        gio_extra_modules = "${glib-networking}/lib/gio/modules";
        gst_plugin_scanner = "${gst_all_1.gstreamer.out}/libexec/gstreamer-1.0/gst-plugin-scanner";
        gst_plugin_system_path = gst_plugin_system_path;
        dcv_sasl_plugin_dir = "${cyrus_sasl.out}/lib/sasl2";
      };
    in
    ''
      # Fix the wrapper script paths.
      patch -p1 < ${fixPathsPatch}
      substituteInPlace usr/bin/dcvviewer \
        --replace-fail '@basedir@' "$out"

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
        ./usr/lib64/dcvviewer/libavcodec.so.62 \
        ./usr/lib64/dcvviewer/libavutil.so.60 \
        ./usr/lib64/dcvviewer/libdcv.so \
        $out/lib64/dcvviewer

      mv usr/share $out/
      rm -rf $out/usr/share/doc

      ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
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
