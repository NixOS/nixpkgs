{ channel, version, revision, sha256 }:

{ stdenv
, fetchurl
, lib

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
}:

let

  baseName = "microsoft-edge";

  shortName = if channel == "stable"
              then "msedge"
              else "msedge-" + channel;

  longName = if channel == "stable"
             then baseName
             else baseName + "-" + channel;

  iconSuffix = if channel == "stable"
               then ""
               else "_${channel}";

  desktopSuffix = if channel == "stable"
                  then ""
                  else "-${channel}";
in

stdenv.mkDerivation rec {
  name="${baseName}-${channel}-${version}";

  src = fetchurl {
    url = "https://packages.microsoft.com/repos/edge/pool/main/m/${baseName}-${channel}/${baseName}-${channel}_${version}-${revision}_amd64.deb";
    inherit sha256;
  };

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
        gtk3 pango cairo gdk-pixbuf mesa
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
        xorg.libX11 xorg.libXext xorg.libxcb wayland
      ];
      libsmartscreenn = lib.makeLibraryPath [
        libuuid
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
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath.naclHelper}" \
      opt/microsoft/${shortName}/nacl_helper

    patchelf \
      --set-rpath "${libPath.libwidevinecdm}" \
      opt/microsoft/${shortName}/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

    patchelf \
      --set-rpath "${libPath.libGLESv2}" \
      opt/microsoft/${shortName}/libGLESv2.so

    patchelf \
      --set-rpath "${libPath.libsmartscreenn}" \
      opt/microsoft/${shortName}/libsmartscreenn.so

    patchelf \
      --set-rpath "${libPath.liboneauth}" \
      opt/microsoft/${shortName}/liboneauth.so
  '';

  installPhase = ''
    mkdir -p $out
    cp -R opt usr/bin usr/share $out

    ${if channel == "stable"
      then ""
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
      --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "xdg_system_dirs=/usr/local/share/:/usr/share/" "xdg_system_dirs=/run/current-system/sw/share/" \
      --replace /usr/bin/file ${file}/bin/file

    substituteInPlace $out/opt/microsoft/${shortName}/default-app-block \
      --replace /opt/microsoft/${shortName} $out/opt/microsoft/${shortName}

    substituteInPlace $out/opt/microsoft/${shortName}/xdg-settings \
      --replace "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" "''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --replace "''${XDG_CONFIG_DIRS:-/etc/xdg}" "''${XDG_CONFIG_DIRS:-/run/current-system/sw/etc/xdg}"
  '';

  meta = with lib; {
    homepage = "https://www.microsoft.com/en-us/edge";
    description = "The web browser from Microsoft";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zanculmarktum kuwii ];
  };
}
