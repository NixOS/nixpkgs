{
  alsa-lib,
  asar,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  copyDesktopItems,
  cairo,
  cups,
  dbus,
  expat,
  fetchurl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  lib,
  libdrm,
  libgbm,
  libGL,
  libglvnd,
  libnotify,
  libpulseaudio,
  libsecret,
  libuuid,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxml2,
  libxrandr,
  libxrender,
  libxshmfence,
  libxt,
  libxtst,
  makeDesktopItem,
  makeWrapper,
  mesa,
  nspr,
  nss,
  pango,
  passwordStore ? "basic",
  stdenv,
  systemd,
  vulkan-loader,
  wayland,
  xdg-utils,
}:

let
  desktopLibs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk3
    libdrm
    libgbm
    libGL
    libglvnd
    libnotify
    libpulseaudio
    libsecret
    libuuid
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxml2
    libxrandr
    libxrender
    libxshmfence
    libxt
    libxtst
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    vulkan-loader
    wayland
  ];

  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  systemSource =
    sources.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "antigravity-hub";
  version = sources.version;

  src = fetchurl {
    url = systemSource.url;
    hash = systemSource.sha256;
  };

  sourceRoot = systemSource.sourceRoot;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    asar
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = desktopLibs;

  desktopItems = [
    (makeDesktopItem {
      name = "antigravity-hub";
      desktopName = "Antigravity";
      comment = "Antigravity 2 - Agent-first development platform";
      exec = "antigravity %U";
      icon = "antigravity";
      terminal = false;
      type = "Application";
      categories = [ "Development" ];
      startupWMClass = "antigravity";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/antigravity
    cp -r . $out/share/antigravity/

    mkdir -p $out/bin
    makeWrapper $out/share/antigravity/antigravity $out/bin/antigravity \
      --add-flags "--no-sandbox" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      ${lib.optionalString (passwordStore != "") "--add-flags --password-store=${passwordStore}"} \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --suffix PATH : /nix/store \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath desktopLibs} \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"

    asar extract-file resources/app.asar icon.png
    install -Dm644 icon.png $out/share/icons/hicolor/512x512/apps/antigravity.png

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop environment for managing multiple autonomous agents across independent projects.";
    homepage = "https://antigravity.google";
    changelog = "https://antigravity.google/changelog";
    downloadPage = "https://antigravity.google/download";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "antigravity";
    maintainers = with lib.maintainers; [
      BohdanTkachenko
    ];
  };
}
