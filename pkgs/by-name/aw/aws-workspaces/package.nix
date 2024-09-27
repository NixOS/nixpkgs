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
  libsoup_2_4,
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
  fontconfig,
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
  gtk3,
  writeShellApplication,
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

      runHook postInstall
    '';
  });

  # Source: https://github.com/jthomaschewski/pkgbuilds/pull/3
  # Credits to https://github.com/rwolfson
  custom_lsb_release = writeShellApplication {
    name = "lsb_release";

    text = ''
      # "Fake" lsb_release script
      # This only exists so that "lsb_release -r" will return the below string
      # when placed in the $PATH

      if [ "$#" -ne 1 ] || [ "$1" != "-r" ] ; then
          echo "Expected only '-r' argument"
          exit 1
      fi

      echo "Release: 22.04"
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aws-workspaces";
  version = "2024.8.5191";

  src = fetchurl {
    urls = [
      # Check new version at https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/jammy/main/binary-amd64/Packages
      "https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/jammy/main/binary-amd64/workspacesclient_${finalAttrs.version}_amd64.deb"
      "https://d3nt0h4h6pmmc4.cloudfront.net/new_workspacesclient_jammy_amd64.deb"
    ];
    hash = "sha256-BDxMycVgWciJZe8CtElXaWVnqYDQO5NmawK10GvP2+k=";
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
    (lib.getLib stdenv.cc.cc)
    atk
    cairo
    curl
    custom_jbigkit
    ffmpeg_6.lib
    gdk-pixbuf
    glib
    glib-networking
    graphicsmagick_q16
    gsettings-desktop-schemas
    gtk3
    hiredis
    icu70
    libfido2
    libkrb5
    libpulseaudio
    librsvg
    libsoup_2_4
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
    webkitgtk_4_1
    xorg.libxcb
    zlib
  ];

  unpackPhase = ''
    runHook preUnpack
    ${dpkg}/bin/dpkg -x $src $out
    mv $out/usr/share $out/share
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    mv $out/usr/lib/x86_64-linux-gnu/workspacesclient/dcv $out/lib/

    rm -rf $out/opt

    # We introduce a dependency on the source file so that it need not be redownloaded everytime
    echo $src >> "$out/share/workspace_dependencies.pin"

    # Remove the vendored-in libgio-2.0.so.0, so the system one is used
    # The vendored-in version has libselinux.so.1 linked, which doesn't exist natively on NixOS
    rm $out/lib/dcv/libgio-2.0.so.0

    wrapProgram $out/usr/bin/workspacesclient \
      --prefix PATH : "$out/lib/dcv":"${lib.makeBinPath [ custom_lsb_release ]}" \
      --prefix LD_LIBRARY_PATH : "$out/lib/dcv":"${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --set-default FONTCONFIG_FILE "${fontconfig.out}/etc/fonts/fonts.conf" \
      --set-default FONTCONFIG_PATH "${fontconfig.out}/etc/fonts" \
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1

    mv $out/usr/bin/workspacesclient $out/bin/workspacesclient

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
