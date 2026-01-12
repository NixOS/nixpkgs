{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  genericUpdater,
  writeShellScript,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  dbus,
  harfbuzz,
  libz,
  libGLU,
  libGL,
  pango,
  xorg,
  minizip,
  lsb-release,
  freetype,
  fontconfig,
  polkit,
  polkit_gnome,
  pciutils,
  copyDesktopItems,
  pulseaudio,
}:

let
  description = "Desktop sharing application, providing remote support and online meetings";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "anydesk";
  version = "7.1.0";

  src = fetchurl {
    urls = [
      "https://download.anydesk.com/linux/anydesk-${finalAttrs.version}-amd64.tar.gz"
      "https://download.anydesk.com/linux/generic-linux/anydesk-${finalAttrs.version}-amd64.tar.gz"
    ];
    hash = "sha256-CplmZZrlnMjmnpOvzFMiSGMnnSNXnXiUtleXi0X52lo=";
  };

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    dbus
    harfbuzz
    libz
    stdenv.cc.cc
    pango
    libGLU
    libGL
    minizip
    freetype
    fontconfig
    polkit
    polkit_gnome
    pulseaudio
  ]
  ++ (with xorg; [
    libxcb
    libxkbfile
    libX11
    libXdamage
    libXext
    libXfixes
    libXi
    libXmu
    libXrandr
    libXtst
    libXt
    libICE
    libSM
    libXrender
  ]);

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "AnyDesk";
      exec = "anydesk %u";
      icon = "anydesk";
      desktopName = "AnyDesk";
      genericName = description;
      categories = [ "Network" ];
      startupNotify = false;
    })
  ];

  postPatch = ''
    substituteInPlace systemd/anydesk.service --replace-fail "/usr/bin/anydesk" "$out/bin/anydesk"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{applications,doc/anydesk,icons/hicolor} $out/lib/systemd/system
    install -m755 anydesk $out/bin/anydesk
    cp copyright README $out/share/doc/anydesk
    cp -r icons/hicolor/* $out/share/icons/hicolor/
    cp systemd/anydesk.service $out/lib/systemd/system/anydesk.service

    runHook postInstall
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      $out/bin/anydesk

    wrapProgram $out/bin/anydesk \
      --prefix PATH : ${
        lib.makeBinPath [
          lsb-release
          pciutils
        ]
      } \
      --prefix GDK_BACKEND : x11 \
      --set GTK_THEME Adwaita
  '';

  passthru = {
    updateScript = genericUpdater {
      versionLister = writeShellScript "anydesk-versionLister" ''
        curl -s https://anydesk.com/en/downloads/linux \
          | grep "https://[a-z0-9._/-]*-amd64.tar.gz" -o \
          | uniq \
          | sed 's,.*/anydesk-\(.*\)-amd64.tar.gz,\1,g'
      '';
    };
  };

  meta = {
    inherit description;
    homepage = "https://www.anydesk.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
