{ stdenv, lib
, makeWrapper, dpkg, fetchurl, autoPatchelfHook
, curl, libkrb5, lttng-ust, libpulseaudio, gtk3, openssl_1_1, icu70, webkitgtk, librsvg, gdk-pixbuf, libsoup, glib-networking, graphicsmagick_q16, libva, libusb1, hiredis, xcbutil
}:

stdenv.mkDerivation rec {
  pname = "aws-workspaces";
  version = "4.6.0.4187";

  src = fetchurl {
    # ref https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/focal/main/binary-amd64/Packages
    urls = [
      "https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/focal/main/binary-amd64/workspacesclient_${version}_amd64.deb"
      "https://archive.org/download/workspacesclient_${version}_amd64/workspacesclient_${version}_amd64.deb"
    ];
    sha256 = "sha256-A+b79ewh4hBIf8jgK0INILFktTqRRpOgXRH0FGziV6c=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # Crashes at startup when stripping:
  # "Failed to create CoreCLR, HRESULT: 0x80004005"
  dontStrip = true;

  buildInputs = [
    stdenv.cc.cc.lib
    libkrb5
    curl
    lttng-ust
    libpulseaudio
    gtk3
    openssl_1_1.out
    icu70
    webkitgtk
    librsvg
    gdk-pixbuf
    libsoup
    glib-networking
    graphicsmagick_q16
    hiredis
    libusb1
    libva
    xcbutil
  ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src $out
  '';

  preFixup = ''
    patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so $out/lib/libcoreclrtraceptprovider.so
    patchelf --replace-needed libGraphicsMagick++-Q16.so.12 libGraphicsMagick++.so.12 $out/usr/lib/x86_64-linux-gnu/pcoip-client/vchan_plugins/libvchan-plugin-clipboard.so
    patchelf --replace-needed libhiredis.so.0.14 libhiredis.so $out/lib/libpcoip_core.so
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    mv $out/opt/workspacesclient/* $out/lib
    rm -rf $out/opt

    wrapProgram $out/lib/workspacesclient \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --set GIO_EXTRA_MODULES "${glib-networking.out}/lib/gio/modules"

    mv $out/lib/workspacesclient $out/bin
  '';

  meta = with lib; {
    description = "Client for Amazon WorkSpaces, a managed, secure Desktop-as-a-Service (DaaS) solution";
    homepage = "https://clients.amazonworkspaces.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ]; # TODO Mac support
    maintainers = with maintainers; [ mausch dylanmtaylor ];
  };
}
