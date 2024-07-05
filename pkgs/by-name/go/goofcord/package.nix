{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  ffmpeg,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libappindicator-gtk3,
  libdrm,
  libnotify,
  libpulseaudio,
  libsecret,
  libuuid,
  libxkbcommon,
  mesa,
  nss,
  pango,
  systemd,
  xdg-utils,
  xorg,
  wayland,
  pipewire,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goofcord";
  version = "1.4.3";

  src =
    let
      base = "https://github.com/Milkshiift/GoofCord/releases/download";
    in
    {
      x86_64-linux = fetchurl {
        url = "${base}/v${finalAttrs.version}/GoofCord-${finalAttrs.version}-linux-amd64.deb";
        hash = "sha256-XO/T5O6+hJ6QT8MCVorrdXPZZlrywa6u0UKPk9WIQBE=";
      };
      aarch64-linux = fetchurl {
        url = "${base}/v${finalAttrs.version}/GoofCord-${finalAttrs.version}-linux-arm64.deb";
        hash = "sha256-4mJ3kDQ+eh9LnyzxyNYvd2hMmgiJtBMXKup7ILlHk0Y=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeShellWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    pango
    systemd
    mesa # for libgbm
    nss
    libuuid
    libdrm
    libnotify
    libsecret
    libpulseaudio
    libxkbcommon
    libappindicator-gtk3
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
    wayland
    pipewire
  ];

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    # use makeShellWrapper (instead of the makeBinaryWrapper provided by wrapGAppsHook3) for proper shell variable expansion
    # see https://github.com/NixOS/nixpkgs/issues/172583
    makeShellWrapper $out/opt/GoofCord/goofcord $out/bin/goofcord \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer}}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    # Fix desktop link
    substituteInPlace $out/share/applications/goofcord.desktop \
      --replace /opt/GoofCord/ ""

    runHook postInstall
  '';

  meta = with lib; {
    description = "Highly configurable and privacy-focused Discord client";
    homepage = "https://github.com/Milkshiift/GoofCord";
    downloadPage = "https://github.com/Milkshiift/GoofCord";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.osl3;
    maintainers = with maintainers; [ nyanbinary ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "goofcord";
  };
})
