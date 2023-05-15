{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, makeWrapper
, wrapGAppsHook
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, ffmpeg
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libappindicator-gtk3
, libdbusmenu
, libdrm
, libnotify
, libpulseaudio
, libsecret
, libuuid
, libxkbcommon
, mesa
, nss
, pango
, systemd
, xdg-utils
, xorg
, wayland
, pipewire
}:

stdenv.mkDerivation rec {
  pname = "armcord";
  version = "3.1.7";

  src =
    let
      base = "https://github.com/ArmCord/ArmCord/releases/download";
    in
      {
        x86_64-linux = fetchurl {
          url = "${base}/v${version}/ArmCord_${version}_amd64.deb";
          sha256 = "sha256-c0ejSivQbxpPUQ6P0YUya3q1EJ1yF4RFGur11BMwz3o=";
        };
        aarch64-linux = fetchurl {
          url = "${base}/v${version}/ArmCord_${version}_arm64.deb";
          sha256 = "sha256-4yqe4eIO4AxsZNYCn99KTBqjQURB+G+gpT0Q17pcEvU=";
        };
      }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook dpkg makeWrapper wrapGAppsHook ];

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
    makeWrapper $out/opt/ArmCord/armcord $out/bin/armcord \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=UseOzonePlatform --enable-features=WebRTCPipeWireCapturer }}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    # Fix desktop link
    substituteInPlace $out/share/applications/armcord.desktop \
      --replace /opt/ArmCord/ $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight, alternative desktop client for Discord";
    homepage = "https://github.com/ArmCord/ArmCord";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.osl3;
    maintainers = with maintainers; [ wrmilling ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
