{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, python3
, glib
, xorg
, numactl
, nss
, atk
, at-spi2-atk
, cups
, dbus
, wayland
, libdrm
, gtk3
, pango
, cairo
, gdk-pixbuf
, libXcomposite
, libXdamage
, libunity
, libXfixes
, libXrandr
, mesa
, expat
, libxkbcommon
, alsa-lib
, at-spi2-core
, fontconfig
, freetype
, libcxx
, libglvnd
, libnotify
, libpulseaudio
, libuuid
, libX11
, libXScrnSaver
, libXcursor
, libXext
, libXi
, libXrender
, libXtst
, libxcb
, libxshmfence
, nspr
, systemd
, libappindicator-gtk3
, libdbusmenu
, makeShellWrapper
}:

stdenv.mkDerivation rec {
  pname = "chia-desktop-bin";
  version = "2.1.4";

  src =
    if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl
        {
          url = "https://github.com/Chia-Network/chia-blockchain/releases/download/${version}/chia-blockchain_${version}_arm64.deb";
          sha256 = "e3c4b3c1c1e088c6a296cd1d531c049694536b0ed57af87509e0b608e61b17db";
        } else
      fetchurl {
        url = "https://github.com/Chia-Network/chia-blockchain/releases/download/${version}/chia-blockchain_${version}_amd64.deb";
        sha256 = "5b57b1728f063e405d13307a6a54b578c7858572ec92f5d82eaab2bb18c8f0e3";
      };


  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    python3
    glib
    xorg.libX11
    xorg.libXext
    xorg.libxcb
    numactl
    nss
    atk
    at-spi2-atk
    cups
    dbus
    libdrm
    gtk3
    pango
    cairo
    gdk-pixbuf
    libXcomposite
    libXdamage
    libXfixes
    libXrandr
    mesa
    expat
    libxkbcommon
    alsa-lib
    at-spi2-core
    autoPatchelfHook
    cups
    libdrm
    libuuid
    libXdamage
    libX11
    libXScrnSaver
    libXtst
    libxcb
    libxshmfence
    mesa
    nss
    makeShellWrapper
  ];

  libPath = lib.makeLibraryPath ([
    libcxx
    systemd
    libpulseaudio
    libdrm
    mesa
    stdenv.cc.cc
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libglvnd
    libnotify
    libX11
    libXcomposite
    libunity
    libuuid
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    nspr
    libxcb
    pango
    libXScrnSaver
    libappindicator-gtk3
    libdbusmenu
    wayland
  ]);

  unpackPhase = "dpkg-deb -R $src .";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv opt $out/opt
    mv usr/share $out/share
    chmod +x $out/opt/chia/chia-blockchain
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/chia/chia-blockchain
    wrapProgramShell $out/opt/chia/chia-blockchain \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/chia
    ln -s $out/opt/chia/chia-blockchain $out/bin/chia-desktop
    runHook postInstall
  '';

  outputs = [ "out" ];

  meta = {
    description = "A blockchain and smart transaction platform that allows users to build decentralized applications.";
    homepage = "https://www.chia.net/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ abueide ];
    platforms = lib.platforms.linux;
  };
}
