{ lib
, stdenv
, fetchurl
, glib
, libX11
, gst_all_1
, libepoxy
, pango
, cairo
, gdk-pixbuf
, e2fsprogs
, libkrb5
, libva
, openssl
, pcsclite
, gtk3
, libselinux
, libxml2
, libffi
, python3Packages
, cpio
, autoPatchelfHook
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "nice-dcv-client";
  version = "2021.2.3797-1";
  src =
    fetchurl {
      url = "https://d1uj6qtbmh3dt5.cloudfront.net/2021.2/Clients/nice-dcv-viewer-${version}.el8.x86_64.rpm";
      sha256 = "sha256-iLz25SB5v7ghkAZOMGPmpNaPihd8ikzCQS//r1xBNRU=";
    };

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook python3Packages.rpm ];
  unpackPhase = ''
    rpm2cpio $src | ${cpio}/bin/cpio -idm
  '';

  buildInputs = [
    libselinux
    libkrb5
    libxml2
    libva
    e2fsprogs
    libX11
    openssl
    pcsclite
    gtk3
    cairo
    libepoxy
    pango
    gdk-pixbuf
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/lib64/
    mv usr/bin/dcvviewer $out/bin/dcvviewer
    mv usr/lib64/* $out/lib64/
    mkdir -p $out/libexec/dcvviewer
    mv usr/libexec/dcvviewer/dcvviewer $out/libexec/dcvviewer/dcvviewer
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/libexec/dcvviewer/dcvviewer
    # Fix the wrapper script to have the right basedir.
    sed -i "s#basedir=/usr#basedir=$out#" $out/bin/dcvviewer
    mv usr/share $out/

    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas

    # we already ship libffi.so.7
    ln -s ${lib.getLib libffi}/lib/libffi.so $out/lib64/libffi.so.6
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
