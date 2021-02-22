{ stdenv
, lib
, at-spi2-atk
, atk
, buildFHSUserEnv
, dbus
, fetchurl
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gsettings-desktop-schemas
, gtk2
, gtk3-x11
, harfbuzz
, liberation_ttf
, libjpeg
, libtiff
, libudev0-shim
, libuuid
, libX11
, libXcursor
, libXext
, libXi
, libXinerama
, libxkbfile
, libxml2
, libXrandr
, libXrender
, libXScrnSaver
, libxslt
, libXtst
, makeDesktopItem
, makeWrapper
, pango
, pcsclite
, pixman
, zlib
}:
let
  version = "2012";

  sysArch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
    else throw "Unsupported system: ${stdenv.hostPlatform.system}";
  # The downloaded archive also contains i386 and ARM binaries, but these have not been tested.

  vmwareHorizonClientFiles = stdenv.mkDerivation {
    name = "vmwareHorizonClientFiles";
    inherit version;
    src = fetchurl {
      url = "https://download3.vmware.com/software/view/viewclients/CART21FQ4/VMware-Horizon-Client-Linux-2012-8.1.0-17349998.tar.gz";
      sha256 = "0afda1f3116e75a4e7f89990d8ee60ccea5f3bb8a2360652162fa11c795724ce";
    };
    buildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir ext $out
      find ${sysArch} -type f -print0 | xargs -0n1 tar -Cext --strip-components=1 -xf
      mv ext/bin ext/lib ext/share "$out"/

      # Horizon includes a copy of libstdc++ which is loaded via $LD_LIBRARY_PATH
      # when it cannot detect a new enough version already present on the system.
      # The checks are distribution-specific and do not function correctly on NixOS.
      # Deleting the bundled library is the simplest way to force it to use our version.
      rm "$out/lib/vmware/gcc/libstdc++.so.6"

      # This libjpeg library interferes with Chromium, so we will be using ours instead.
      rm $out/lib/vmware/libjpeg.*

      # Force the default GTK theme (Adwaita) because Horizon is prone to
      # UI usability issues when using non-default themes, such as Adwaita-dark.
      makeWrapper "$out/bin/vmware-view" "$out/bin/vmware-view_wrapper" \
          --set GTK_THEME Adwaita \
          --suffix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
          --suffix LD_LIBRARY_PATH : "$out/lib/vmware/view/crtbora:$out/lib/vmware"
    '';
  };

  vmwareFHSUserEnv = buildFHSUserEnv {
    name = "vmware-view";

    runScript = "${vmwareHorizonClientFiles}/bin/vmware-view_wrapper";

    targetPkgs = pkgs: [
      at-spi2-atk
      atk
      dbus
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk2
      gtk3-x11
      harfbuzz
      liberation_ttf
      libjpeg
      libtiff
      libudev0-shim
      libuuid
      libX11
      libXcursor
      libXext
      libXi
      libXinerama
      libxkbfile
      libxml2
      libXrandr
      libXrender
      libXScrnSaver
      libXtst
      pango
      pcsclite
      pixman
      vmwareHorizonClientFiles
      zlib
    ];
  };

  desktopItem = makeDesktopItem {
    name = "vmware-view";
    desktopName = "VMware Horizon Client";
    icon = "${vmwareHorizonClientFiles}/share/icons/vmware-view.png";
    exec = "${vmwareFHSUserEnv}/bin/vmware-view %u";
    mimeType = "x-scheme-handler/vmware-view";
  };

in
stdenv.mkDerivation {
  name = "vmware-view";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cp "${desktopItem}"/share/applications/* $out/share/applications/
    ln -s "${vmwareFHSUserEnv}/bin/vmware-view" "$out/bin/"
  '';

  unwrapped = vmwareHorizonClientFiles;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Allows you to connect to your VMware Horizon virtual desktop";
    homepage = "https://www.vmware.com/go/viewclients";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buckley310 ];
  };
}
