{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, makeWrapper
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
}:

stdenv.mkDerivation rec {
  pname = "armcord";
  version = "3.0.7";

  src = let
    base = "https://github.com/ArmCord/ArmCord/releases/download";
  in {
    x86_64-linux = fetchurl {
      url = "${base}/v${version}/ArmCord_${version}_amd64.deb";
      sha256 = "b2a583e6abbc6e5dc3f7370a33f21fc4e7963c6cbe7555e954156c77e9577261";
    };
    aarch64-linux = fetchurl {
      url = "${base}/v${version}/ArmCord_${version}_arm64.deb";
      sha256 = "8c32a14ab8e5bdf865a6523cb4b5cec8f3f870b95f99be9661a4dd0df33aae1d";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook dpkg makeWrapper ];

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
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      "''${gappsWrapperArgs[@]}"

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
