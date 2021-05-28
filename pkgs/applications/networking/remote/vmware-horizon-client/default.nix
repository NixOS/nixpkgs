{ stdenv, buildFHSUserEnv, fetchurl, makeWrapper, makeDesktopItem, libxslt, atk
, fontconfig, freetype, gdk-pixbuf, glib, gtk2, libudev0-shim, libxml2
, pango, pixman, libX11, libXext, libXinerama, libXrandr , libXrender
, libXtst, libXcursor, libXi, libxkbfile , libXScrnSaver, zlib, liberation_ttf
, libtiff, dbus, at-spi2-atk, harfbuzz, gtk3-x11, libuuid, pcsclite
}:

let
  version = "2006";

  sysArch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
    else throw "Unsupported system: ${stdenv.hostPlatform.system}";
    # The downloaded archive also contains i386 and ARM binaries, but these have not been tested.

  vmwareHorizonClientFiles = stdenv.mkDerivation {
    name = "vmwareHorizonClientFiles";
    inherit version;
    src = fetchurl {
      url = https://download3.vmware.com/software/view/viewclients/CART21FQ2/vmware-view-client-linux-2006-8.0.0-16522670.tar.gz;
      sha256 = "8c46d49fea42f8c1f7cf32a5f038f5a47d2b304743b1e4f4c68c658621b0e79c";
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
      rm -f "$out/lib/vmware/gcc/libstdc++.so.6"

      # Force the default GTK theme (Adwaita) because Horizon is prone to
      # UI usability issues when using non-default themes, such as Adwaita-dark.
      makeWrapper "$out/bin/vmware-view" "$out/bin/vmware-view_wrapper" \
          --set GTK_THEME Adwaita \
          --suffix LD_LIBRARY_PATH : "$out/lib/vmware/view/crtbora:$out/lib/vmware"
    '';
  };

  vmwareFHSUserEnv = buildFHSUserEnv {
    name = "vmware-view";

    runScript = "${vmwareHorizonClientFiles}/bin/vmware-view_wrapper";

    targetPkgs = pkgs: [
      pcsclite dbus vmwareHorizonClientFiles atk fontconfig freetype gdk-pixbuf glib gtk2
      libudev0-shim libxml2 pango pixman liberation_ttf libX11 libXext libXinerama
      libXrandr libXrender libXtst libXcursor libXi libxkbfile at-spi2-atk libXScrnSaver
      zlib libtiff harfbuzz gtk3-x11 libuuid
    ];
  };

  desktopItem = makeDesktopItem {
    name = "vmware-view";
    desktopName = "VMware Horizon Client";
    icon = "${vmwareHorizonClientFiles}/share/icons/vmware-view.png";
    exec = "${vmwareFHSUserEnv}/bin/vmware-view %u";
    mimeType = "x-scheme-handler/vmware-view";
  };

in stdenv.mkDerivation {
  name = "vmware-view";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cp "${desktopItem}"/share/applications/* $out/share/applications/
    ln -s "${vmwareFHSUserEnv}/bin/vmware-view" "$out/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Allows you to connect to your VMware Horizon virtual desktop";
    homepage = "https://www.vmware.com/go/viewclients";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ buckley310 ];
  };
}
