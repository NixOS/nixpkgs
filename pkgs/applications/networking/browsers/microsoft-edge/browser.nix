{ channel, version, revision, hash }:

{ stdenv
, fetchurl
, lib
, makeWrapper

, binutils-unwrapped
, xz
, gnutar
, file

, glibc
, glib
, nss
, nspr
, atk
, at-spi2-atk
, xorg
, cups
, dbus
, expat
, libdrm
, libxkbcommon
, pipewire
, gtk3
, pango
, cairo
, gdk-pixbuf
, mesa
, alsa-lib
, at-spi2-core
, libuuid
, systemd
, wayland
, libGL

# command line arguments which are always set e.g "--disable-gpu"
, commandLineArgs ? ""
}:

let

  baseName = "microsoft-edge";

  shortName = if channel == "stable"
              then "msedge"
              else "msedge-" + channel;

  longName = if channel == "stable"
             then baseName
             else baseName + "-" + channel;

  iconSuffix = lib.optionalString (channel != "stable") "_${channel}";

  desktopSuffix = lib.optionalString (channel != "stable") "-${channel}";
in

stdenv.mkDerivation rec {
  pname="${baseName}-${channel}";
  inherit version;

  src = fetchurl {
    url = "https://packages.microsoft.com/repos/edge/pool/main/m/${baseName}-${channel}/${baseName}-${channel}_${version}-${revision}_amd64.deb";
    inherit hash;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  unpackCmd = "${binutils-unwrapped}/bin/ar p $src data.tar.xz | ${xz}/bin/xz -dc | ${gnutar}/bin/tar -xf -";
  sourceRoot = ".";

  dontPatch = true;
  dontConfigure = true;
  dontPatchELF = true;

  buildPhase = let
    libPath = {
      msedge = lib.makeLibraryPath [
        glibc glib nss nspr atk at-spi2-atk xorg.libX11
        xorg.libxcb cups.lib dbus.lib expat libdrm
        xorg.libXcomposite xorg.libXdamage xorg.libXext
        xorg.libXfixes xorg.libXrandr libxkbcommon
        pipewire gtk3 pango cairo gdk-pixbuf mesa
        alsa-lib at-spi2-core xorg.libxshmfence systemd wayland
      ];
      naclHelper = lib.makeLibraryPath [
        glib nspr atk libdrm xorg.libxcb mesa xorg.libX11
        xorg.libXext dbus.lib libxkbcommon
      ];
      libwidevinecdm = lib.makeLibraryPath [
        glib nss nspr
      ];
      libGLESv2 = lib.makeLibraryPath [
        xorg.libX11 xorg.libXext xorg.libxcb wayland libGL
      ];
      liboneauth = lib.makeLibraryPath [
        libuuid xorg.libX11
      ];
    };
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath.msedge}" \
      opt/microsoft/${shortName}/msedge

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      opt/microsoft/${shortName}/msedge-sandbox

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      opt/microsoft/${shortName}/msedge_crashpad_handler

    patchelf \
      --set-rpath "${libPath.libwidevinecdm}" \
      opt/microsoft/${shortName}/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

    patchelf \
      --set-rpath "${libPath.libGLESv2}" \
      opt/microsoft/${shortName}/libGLESv2.so

    patchelf \
      --set-rpath "${libPath.liboneauth}" \
      opt/microsoft/${shortName}/liboneauth.so
  '' + lib.optionalString (lib.versionOlder version "121") ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath.naclHelper}" \
      opt/microsoft/${shortName}/nacl_helper
  '';

  installPhase = ''
    mkdir -p $out
    cp -R opt usr/bin usr/share $out

    ${if channel == "stable"
      then "ln -sf $out/bin/${longName} $out/bin/${baseName}-${channel}"
      else "ln -sf $out/opt/microsoft/${shortName}/${baseName}-${channel} $out/opt/microsoft/${shortName}/${baseName}"}

    ln -sf $out/opt/microsoft/${shortName}/${longName} $out/bin/${longName}

    rm -rf $out/share/doc
    rm -rf $out/opt/microsoft/${shortName}/cron

    for icon in '16' '24' '32' '48' '64' '128' '256'
    do
      ${ "icon_source=$out/opt/microsoft/${shortName}/product_logo_\${icon}${iconSuffix}.png" }
      ${ "icon_target=$out/share/icons/hicolor/\${icon}x\${icon}/apps" }
      mkdir -p $icon_target
      cp $icon_source $icon_target/microsoft-edge${desktopSuffix}.png
    done

    substituteInPlace $out/share/applications/${longName}.desktop \
      --replace /usr/bin/${baseName}-${channel} $out/bin/${longName}

    substituteInPlace $out/share/gnome-control-center/default-apps/${longName}.xml \
      --replace /opt/microsoft/${shortName} $out/opt/microsoft/${shortName}

    substituteInPlace $out/share/menu/${longName}.menu \
      --replace /opt/microsoft/${shortName} $out/opt/microsoft/${shortName}

    substituteInPlace $out/opt/microsoft/${shortName}/xdg-mime \
      --replace "\''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "\''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "xdg_system_dirs=/usr/local/share/:/usr/share/" "xdg_system_dirs=/run/current-system/sw/share/" \
      --replace /usr/bin/file ${file}/bin/file

    substituteInPlace $out/opt/microsoft/${shortName}/default-app-block \
      --replace /opt/microsoft/${shortName} $out/opt/microsoft/${shortName}

    substituteInPlace $out/opt/microsoft/${shortName}/xdg-settings \
      --replace "\''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "\''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "\''${XDG_CONFIG_DIRS:-/etc/xdg}" "\''${XDG_CONFIG_DIRS:-/run/current-system/sw/etc/xdg}"
  '';

  postFixup = ''
    wrapProgram "$out/bin/${longName}" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.pname}-${gtk3.version}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  '';

  # We only want automatic updates for stable, beta and dev will get updated by the same script
  # and are only used for testing.
  passthru = lib.optionalAttrs (channel == "stable") { updateScript = ./update.py; };

  meta = with lib; {
    homepage = "https://www.microsoft.com/en-us/edge";
    description = "Web browser from Microsoft";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zanculmarktum kuwii rhysmdnz ];
  };
}
