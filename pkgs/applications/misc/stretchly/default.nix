{ GConf
, alsaLib
, at-spi2-atk
, at-spi2-core
, atk
, buildFHSUserEnv
, cairo
, common-updater-scripts
, coreutils
, cups
, dbus
, expat
, fetchurl
, fontconfig
, gdk-pixbuf
, glib
, gtk2
, gtk3
, lib
, libX11
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libappindicator
, libdrm
, libnotify
, libpciaccess
, libpng12
, libuuid
, libxcb
, nspr
, nss
, pango
, pciutils
, pulseaudio
, runtimeShell
, stdenv
, udev
, wrapGAppsHook
, writeScript
, file
}:

let
  libs = [
    GConf
    alsaLib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    gdk-pixbuf
    glib
    gtk2
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libappindicator
    libdrm
    libnotify
    libpciaccess
    libpng12
    libuuid
    libxcb
    nspr
    nss
    pango
    pciutils
    pulseaudio
    stdenv.cc.cc.lib
    udev
  ];

  libPath = lib.makeLibraryPath libs;

  stretchly =
    stdenv.mkDerivation rec {
      pname = "stretchly";
      version = "0.21.0";

      src = fetchurl {
        url = "https://github.com/hovancik/stretchly/releases/download/v${version}/stretchly-${version}.tar.xz";
        sha256 = "1gyyr22xq8s4miiacs8wqhp7lxnwvkvlwhngnq8671l62s6iyjzl";
      };

      nativeBuildInputs = [
        wrapGAppsHook
        coreutils
      ];

      buildInputs = libs;

      dontPatchELF = true;
      dontBuild = true;
      dontConfigure = true;

      installPhase = ''
        mkdir -p $out/bin $out/lib/stretchly
        cp -r ./* $out/lib/stretchly/
        ln -s $out/lib/stretchly/stretchly $out/bin/
      '';

      preFixup = ''
        patchelf --set-rpath "${libPath}" $out/lib/stretchly/libffmpeg.so
        patchelf --set-rpath "${libPath}" $out/lib/stretchly/libEGL.so
        patchelf --set-rpath "${libPath}" $out/lib/stretchly/libGLESv2.so
        patchelf --set-rpath "${libPath}" $out/lib/stretchly/swiftshader/libEGL.so
        patchelf --set-rpath "${libPath}" $out/lib/stretchly/swiftshader/libGLESv2.so

        patchelf \
          --set-rpath "$out/lib/stretchly:${libPath}" \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/lib/stretchly/stretchly

        patchelf \
          --set-rpath "$out/lib/stretchly:${libPath}" \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/lib/stretchly/chrome-sandbox
      '';

      meta = with stdenv.lib; {
        description = "A break time reminder app";
        longDescription = ''
          stretchly is a cross-platform electron app that reminds you to take
          breaks when working on your computer. By default, it runs in your tray
          and displays a reminder window containing an idea for a microbreak for 20
          seconds every 10 minutes. Every 30 minutes, it displays a window
          containing an idea for a longer 5 minute break.
        '';
        homepage = https://hovancik.net/stretchly;
        downloadPage = https://hovancik.net/stretchly/downloads/;
        license = licenses.bsd2;
        maintainers = with maintainers; [ cdepillabout ];
        platforms = platforms.linux;
      };
    };

in

buildFHSUserEnv {
  inherit (stretchly) meta;

  name = "stretchly";

  targetPkgs = pkgs: [
     stretchly
  ];

  runScript = "stretchly";

  passthru = {
    updateScript = writeScript "update-stretchly" ''
      #!${runtimeShell}

      set -eu -o pipefail

      # get the latest release version
      latest_version=$(curl -s https://api.github.com/repos/hovancik/stretchly/releases/latest | jq --raw-output .tag_name | sed -e 's/^v//')

      echo "updating to $latest_version..."

      ${common-updater-scripts}/bin/update-source-version stretchly.passthru.stretchlyWrapped "$latest_version"
    '';

    stretchlyWrapped = stretchly;
  };
}
