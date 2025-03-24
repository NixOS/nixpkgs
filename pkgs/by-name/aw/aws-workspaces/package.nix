{
  stdenv,
  lib,
  libpsl,
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
  libsoup_3,
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
  publicsuffixList ? (import <nixpkgs> { }).publicsuffix-list,
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
    dpkg
    autoPatchelfHook
    copyDesktopItems
    wrapGAppsHook4
    glib
  ];

  # Crashes at startup when stripping:
  # "Failed to create CoreCLR, HRESULT: 0x80004005"
  dontStrip = true;

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    atk
    cairo
    curl
    jbigkit
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
    libsoup_3
    libtiff
    libusb1
    libva
    libpsl
    libvdpau
    lmdb
    lttng-ust
    openssl
    pango
    publicsuffixList
    pcsclite
    protobufc
    sssd
    webkitgtk_4_1
    xorg.libxcb
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec
    cp -R usr/* $out/
    mv $out/lib/x86_64-linux-gnu/workspacesclient/dcv $out/libexec/
    rm -rf $out/opt

    # We introduce a dependency on the source file so that it need not be redownloaded everytime
    echo $src >> "$out/share/workspace_dependencies.pin"

    # Remove the vendored-in libgio-2.0.so.0, so the system one is used
    # The vendored-in version has libselinux.so.1 linked, which doesn't exist natively on NixOS
    rm $out/libexec/dcv/libgio-2.0.so.0

    glib-compile-schemas $out/share/glib-2.0/schemas/

    mkdir -p $out/share/publicsuffix
    cp ${publicsuffixList}/share/publicsuffix/public_suffix_list.dat $out/share/publicsuffix/

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "$out/libexec/dcv":"${lib.makeBinPath [ custom_lsb_release ]}" \
    )
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
