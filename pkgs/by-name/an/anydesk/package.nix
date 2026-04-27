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
  libxt,
  libxtst,
  libxrender,
  libxrandr,
  libxmu,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libx11,
  libsm,
  libice,
  libxkbfile,
  libxcb,
  minizip,
  net-tools,
  lsb-release,
  freetype,
  fontconfig,
  polkit,
  polkit_gnome,
  pciutils,
  copyDesktopItems,
  pulseaudio,
  udev,
}:

let
  description = "Desktop sharing application, providing remote support and online meetings";
  pin = lib.importJSON ./pin.json;
  inherit (pin) version;
  inherit (stdenv.hostPlatform) system;
  url =
    if system == "x86_64-linux" then
      "https://download.anydesk.com/linux/anydesk-${version}-amd64.tar.gz"
    else if system == "aarch64-linux" then
      "https://download.anydesk.com/rpi/anydesk-${version}-arm64.tar.gz"
    else
      throw "cannot install AnyDesk on ${system}";
  hash = pin.${system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "anydesk";
  inherit version;

  src = fetchurl {
    inherit url hash;
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
    libxcb
    libxkbfile
    libx11
    libxdamage
    libxext
    libxfixes
    libxi
    libxmu
    libxrandr
    libxtst
    libxt
    libice
    libsm
    libxrender
    udev
  ];

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
      --suffix PATH : ${
        lib.makeBinPath [
          net-tools
        ]
      } \
      --set GTK_THEME Adwaita
  '';

  passthru = {
    updateScript = genericUpdater {
      versionLister =
        let
          arch =
            if system == "x86_64-linux" then
              "amd64"
            else if system == "aarch64-linux" then
              "arm64"
            else
              throw "cannot update AnyDesk on ${system}";
        in
        writeShellScript "anydesk-versionLister" ''
          curl -s https://anydesk.com/en/downloads/linux \
            | grep "https://[a-z0-9._/-]*-${arch}.tar.gz" -o \
            | uniq \
            | sed 's,.*/anydesk-\(.*\)-${arch}.tar.gz,\1,g'
        '';
    };
  };

  meta = {
    inherit description;
    homepage = "https://www.anydesk.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "anydesk";
    maintainers = [ ];
  };
})
