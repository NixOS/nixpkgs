{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
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

stdenv.mkDerivation rec {
  pname = "legcord";
  version = "1.0.2";

  src =
    let
      base = "https://github.com/Legcord/Legcord/releases/download";
    in
    {
      x86_64-linux = fetchurl {
        url = "${base}/v${version}/Legcord-${version}-linux-amd64.deb";
        hash = "sha256-MvSnYE6JLnZUA/Td0XuvOAENEtMGWSQuFFDa8cnBB1s=";
      };
      aarch64-linux = fetchurl {
        url = "${base}/v${version}/Legcord-${version}-linux-arm64.deb";
        hash = "sha256-+HD162RfcNxNXpjW5HPAmhCQIFRXuPXdC/jQgT0aV1k=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
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

    # Wrap the startup command
    makeBinaryWrapper $out/opt/Legcord/legcord $out/bin/legcord \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=UseOzonePlatform --enable-features=WebRTCPipeWireCapturer }}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    # Fix desktop link
    substituteInPlace $out/share/applications/legcord.desktop \
      --replace /opt/Legcord/ $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight, alternative desktop client for Discord";
    homepage = "https://legcord.app";
    downloadPage = "https://github.com/Legcord/Legcord";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.osl3;
    maintainers = with maintainers; [ wrmilling ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "legcord";
  };
}
