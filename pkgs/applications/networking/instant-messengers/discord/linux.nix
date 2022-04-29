{ pname, version, src, meta, binaryName, desktopName, autoPatchelfHook
, makeDesktopItem, lib, stdenv, wrapGAppsHook, alsa-lib, at-spi2-atk
, at-spi2-core, atk, cairo, cups, dbus, expat, fontconfig, freetype, gdk-pixbuf
, glib, gtk3, libcxx, libdrm, libnotify, libpulseaudio, libuuid, libX11
, libXScrnSaver, libXcomposite, libXcursor, libXdamage, libXext, libXfixes
, libXi, libXrandr, libXrender, libXtst, libxcb, libxshmfence, mesa, nspr, nss
, pango, systemd, libappindicator-gtk3, libdbusmenu, writeScript
, common-updater-scripts }:

stdenv.mkDerivation rec {
  inherit pname version src meta;

  nativeBuildInputs = [
    alsa-lib
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
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  libPath = lib.makeLibraryPath [
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
    libnotify
    libX11
    libXcomposite
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
    nss
    libxcb
    pango
    libXScrnSaver
    libappindicator-gtk3
    libdbusmenu
  ];

  installPhase = ''
    mkdir -p $out/{bin,opt/${binaryName},share/pixmaps}
    mv * $out/opt/${binaryName}

    chmod +x $out/opt/${binaryName}/${binaryName}
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/${binaryName}/${binaryName}

    wrapProgram $out/opt/${binaryName}/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/${binaryName}

    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
    # Without || true the install would fail on case-insensitive filesystems
    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${
      lib.strings.toLower binaryName
    } || true
    ln -s $out/opt/${binaryName}/discord.png $out/share/pixmaps/${pname}.png

    ln -s "${desktopItem}/share/applications" $out/share/
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = binaryName;
    icon = pname;
    inherit desktopName;
    genericName = meta.description;
    categories = [ "Network" "InstantMessaging" ];
    mimeTypes = [ "x-scheme-handler/discord" ];
  };

  passthru.updateScript = writeScript "discord-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnugrep common-updater-scripts
    set -eou pipefail;
    url=$(curl -sI "https://discordapp.com/api/download/${
      builtins.replaceStrings [ "discord-" "discord" ] [ "" "stable" ] pname
    }?platform=linux&format=tar.gz" | grep -oP 'location: \K\S+')
    version=''${url##https://dl*.discordapp.net/apps/linux/}
    version=''${version%%/*.tar.gz}
    update-source-version ${pname} "$version" --file=./pkgs/applications/networking/instant-messengers/discord/default.nix
  '';
}
