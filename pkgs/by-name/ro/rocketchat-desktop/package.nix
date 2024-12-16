{
  lib,
  stdenv,
  pkgs,
  fetchurl,
  wrapGAppsHook3,
}:
let
  libPathNative = { packages }: lib.makeLibraryPath packages;
in
stdenv.mkDerivation rec {
  pname = "rocketchat-desktop";
  version = "4.1.2";

  src = fetchurl {
    url = "https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/${version}/rocketchat-${version}-linux-amd64.deb";
    hash = "sha256-lcMxBEcZkJARFd+ZQTAdLQLVy4/SIi4ps8N798PomyM=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3 # to fully work with gnome also needs programs.dconf.enable = true in your configuration.nix
  ];

  buildInputs = with pkgs; [
    gtk3
    stdenv.cc.cc
    zlib
    glib
    dbus
    atk
    pango
    freetype
    libgnome-keyring
    fontconfig
    gdk-pixbuf
    cairo
    cups
    expat
    libgpg-error
    alsa-lib
    nspr
    nss
    xorg.libXrender
    xorg.libX11
    xorg.libXext
    xorg.libXdamage
    xorg.libXtst
    xorg.libXcomposite
    xorg.libXi
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXcursor
    xorg.libxkbfile
    xorg.libXScrnSaver
    systemd
    libnotify
    xorg.libxcb
    at-spi2-atk
    at-spi2-core
    libdbusmenu
    libdrm
    mesa
    xorg.libxshmfence
    libxkbcommon
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ ./opt/ ./usr/
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv opt $out
    mv usr/share $out
    ln -s $out/opt/Rocket.Chat/rocketchat-desktop $out/bin/rocketchat-desktop
    runHook postInstall
  '';

  postFixup =
    let
      libpath = libPathNative { packages = buildInputs; };
    in
    ''
      app=$out/opt/Rocket.Chat
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libpath}:$app" \
        $app/rocketchat-desktop
      sed -i -e "s|Exec=.*$|Exec=$out/bin/rocketchat-desktop|" $out/share/applications/rocketchat-desktop.desktop
    '';

  meta = with lib; {
    description = "Official Desktop client for Rocket.Chat";
    mainProgram = "rocketchat-desktop";
    homepage = "https://github.com/RocketChat/Rocket.Chat.Electron";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ gbtb ];
    platforms = [ "x86_64-linux" ];
  };
}
