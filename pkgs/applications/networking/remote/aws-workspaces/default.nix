{ stdenv, lib
, makeWrapper, dpkg, fetchurl, autoPatchelfHook
, curl, libkrb5, lttng-ust, libpulseaudio, gtk3, openssl, icu70, webkitgtk, librsvg, gdk-pixbuf, libsoup, glib-networking, graphicsmagick_q16, libva, libusb1, hiredis, pcsclite, jbigkit, libtiff, libvdpau
, ffmpeg_6, lmdb, protobufc, zlib
}:

stdenv.mkDerivation rec {
  pname = "aws-workspaces";
  version = "2023.0.4395";

  src = fetchurl {
    urls = [
      # Original source is https://d3nt0h4h6pmmc4.cloudfront.net/new_workspacesclient_jammy_amd64.deb.
      # It doesn't seem like Amazon provides a repository for Ubuntu 22.04 (jammy) - at least not yet, so I am using archive.org to pin the version.
      "https://archive.org/download/new_workspacesclient_jammy_2023.0.4395_amd64/new_workspacesclient_jammy_2023.0.4395_amd64.deb"
    ];
    sha256 = "sha256-w6056o4mAI39SEq94s5UabdPllCrSaK11LMi97XeDYA=";
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
    openssl
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
    pcsclite
    jbigkit
    libvdpau
    libtiff
    ffmpeg_6.lib
    lmdb
    protobufc
    zlib
  ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src $out
    rm -rf $out/usr/lib/x86_64-linux-gnu/workspacesclient/dcv/g*
    rm -rf $out/usr/lib/x86_64-linux-gnu/workspacesclient/dcv/lib[acefghjlnoptz]*
    ls -alR $out
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    rm -rf $out/opt

    wrapProgram $out/usr/bin/workspacesclient \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --set GIO_EXTRA_MODULES "${glib-networking.out}/lib/gio/modules"

    mv $out/usr/bin/workspacesclient $out/bin/workspacesclient
  '';

  meta = with lib; {
    description = "Client for Amazon WorkSpaces, a managed, secure Desktop-as-a-Service (DaaS) solution";
    homepage = "https://clients.amazonworkspaces.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ]; # TODO Mac support
    maintainers = with maintainers; [ mausch dylanmtaylor ];
    mainProgram = "workspacesclient";
  };
}
