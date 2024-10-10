{
  stdenv,
  lib,
  dpkg,
  fetchurl,
  autoPatchelfHook,
  curl,
  libkrb5,
  lttng-ust,
  libpulseaudio,
  openssl,
  icu70,
  librsvg,
  gdk-pixbuf,
  libsoup,
  glib-networking,
  gsettings-desktop-schemas,
  graphicsmagick_q16,
  libva,
  libusb1,
  hiredis,
  pcsclite,
  jbigkit,
  libvdpau,
  libtiff,
  ffmpeg_6,
  lmdb,
  protobufc,
  zlib,
  cairo,
  pango,
  xorg,
  libfido2,
  webkitgtk_4_1,
  copyDesktopItems,
  wrapGAppsHook4,
  atk,
  fetchpatch,
  glib,
  sssd,
  gtk2,
}:

let
  # To remove when https://github.com/NixOS/nixpkgs/pull/345659 has landed
  custom_jbigkit = jbigkit.overrideAttrs (oldAttrs: {
    patches = oldAttrs.patches ++ [
      (fetchpatch {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jbigkit/-/raw/main/jbigkit-2.1-shared_lib.patch";
        hash = "sha256-+efeeKg3FJ/TjSOj58kD+DwnaCm3zhGzKLfUes/d5rg=";
      })
      (fetchpatch {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jbigkit/-/raw/main/jbigkit-2.1-ldflags.patch";
        hash = "sha256-ik3NifyuhDHnIMTrNLAKInPgu2F5u6Gvk9daqrn8ZhY=";
      })
      # Archlinux patch: update coverity
      (fetchpatch {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jbigkit/-/raw/main/jbigkit-2.1-coverity.patch";
        hash = "sha256-APm9A2f4sMufuY3cnL9HOcSCa9ov3pyzgQTTKLd49/E=";
      })
      # Archlinux patch: fix build warnings
      (fetchpatch {
        url = "https://gitlab.archlinux.org/archlinux/packaging/packages/jbigkit/-/raw/main/jbigkit-2.1-build_warnings.patch";
        hash = "sha256-lDEJ1bvZ+zR7K4CiTq+aXJ8PGjILE3W13kznLLlGOOg=";
      })
    ];

    makeFlags = [
      "AR=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar"
      "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
      "DESTDIR=${placeholder "out"}"
      "RANLIB=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib"
    ];

    installPhase = ''
      runHook preInstall

      install -vDm 644 libjbig/*.h -t "$out/include/"
      install -vDm 755 pbmtools/{jbgtopbm{,85},pbmtojbg{,85}} -t "$out/bin/"
      install -vDm 644 pbmtools/*.1* -t "$out/share/man/man1/"

      install -vDm 755 libjbig/*.so.* -t "$out/lib/"
      for lib in libjbig.so libjbig85.so; do
        ln -sv "$lib.${oldAttrs.version}" "$out/lib/$lib"
        ln -sv "$out/lib/$lib.${oldAttrs.version}" "$out/lib/$lib.0"
      done

      # We introduce a dependency on the source file so that it need not be redownloaded everytime
      echo $src >> "$out/share/workspace_dependencies.pin"

      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aws-workspaces";
  version = "2024.5.5119";

  src = fetchurl {
    urls = [
      # Check new version at https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/jammy/main/binary-amd64/Packages
      "https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/jammy/main/binary-amd64/workspacesclient_${finalAttrs.version}_amd64.deb"
    ];
    hash = "sha256-qkQU9Z2d4T4JPq9iKAZAlROn21dN/9TeaA+9ysYlLzo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    wrapGAppsHook4
  ];

  # Crashes at startup when stripping:
  # "Failed to create CoreCLR, HRESULT: 0x80004005"
  dontStrip = true;

  buildInputs = [
    atk
    cairo
    curl
    ffmpeg_6.lib
    gdk-pixbuf
    glib
    glib-networking
    gsettings-desktop-schemas
    graphicsmagick_q16
    gtk2
    hiredis
    icu70
    custom_jbigkit
    libfido2
    libkrb5
    libpulseaudio
    librsvg
    libsoup
    libtiff
    libusb1
    libva
    libvdpau
    lmdb
    lttng-ust
    openssl
    pango
    pcsclite
    protobufc
    sssd
    stdenv.cc.cc.lib
    webkitgtk_4_1
    xorg.libxcb
    zlib
  ];

  unpackPhase = ''
    runHook preUnpack
    ${dpkg}/bin/dpkg -x $src $out
    ls -la $out
    ls -lR $out
    mv $out/usr/share $out/share
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    rm -rf $out/opt

    wrapProgram $out/usr/bin/workspacesclient \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --set GDK_PIXBUF_MODULE_FILE "${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --set GIO_EXTRA_MODULES "${glib-networking.out}/lib/gio/modules"

    mv $out/usr/bin/workspacesclient $out/bin/workspacesclient

    glib-compile-schemas $out/share/glib-2.0/schemas

    runHook postInstall
  '';

  meta = {
    description = "Client for Amazon WorkSpaces, a managed, secure Desktop-as-a-Service (DaaS) solution";
    homepage = "https://clients.amazonworkspaces.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "workspacesclient";
    maintainers = with lib.maintainers; [
      mausch
      dylanmtaylor
    ];
    platforms = [ "x86_64-linux" ]; # TODO Mac support
  };
})
