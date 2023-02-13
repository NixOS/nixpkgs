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
, imagemagick
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
  pname = "tidal-hifi";
  version = "4.4.0";

  src = fetchurl {
    url = "https://github.com/Mastermindzh/tidal-hifi/releases/download/${version}/tidal-hifi_${version}_amd64.deb";
    sha256 = "sha256-6KlcxBV/zHN+ZnvIu1PcKNeS0u7LqhDqAjbXawT5Vv8=";
  };

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
    imagemagick
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

  runtimeDependencies =
    [ (lib.getLib systemd) libnotify libdbusmenu xdg-utils ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/tidal-hifi/tidal-hifi $out/bin/tidal-hifi \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      "''${gappsWrapperArgs[@]}"
    substituteInPlace $out/share/applications/tidal-hifi.desktop \
      --replace "/opt/tidal-hifi/tidal-hifi" "tidal-hifi"

    for size in 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps/
      convert $out/share/icons/hicolor/0x0/apps/tidal-hifi.png \
        -resize ''${size}x''${size} $out/share/icons/hicolor/''${size}x''${size}/apps/icon.png
    done
  '';

  meta = with lib; {
    description = "The web version of Tidal running in electron with hifi support thanks to widevine";
    homepage = "https://github.com/Mastermindzh/tidal-hifi";
    changelog = "https://github.com/Mastermindzh/tidal-hifi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ qbit ];
    platforms = [ "x86_64-linux" ];
  };
}
