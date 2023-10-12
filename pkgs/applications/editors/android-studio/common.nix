{ channel, pname, version, sha256Hash }:

{ alsa-lib
, bash
, buildFHSEnv
, cacert
, coreutils
, dbus
, e2fsprogs
, expat
, fetchurl
, findutils
, file
, fontsConf
, git
, glxinfo
, gnugrep
, gnused
, gnutar
, gtk2, gnome_vfs, glib, GConf
, gzip
, fontconfig
, freetype
, libpulseaudio
, libGL
, libuuid
, libX11
, libxcb
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, makeWrapper
, ncurses5
, nspr
, nss_latest
, pciutils
, pkgsi686Linux
, ps
, setxkbmap
, lib
, stdenv
, systemd
, unzip
, usbutils
, which
, runCommand
, xkeyboard_config
, zlib
, makeDesktopItem
, tiling_wm # if we are using a tiling wm, need to set _JAVA_AWT_WM_NONREPARENTING in wrapper
}:

let
  drvName = "android-studio-${channel}-${version}";
  filename = "android-studio-${version}-linux.tar.gz";

  androidStudio = stdenv.mkDerivation {
    name = "${drvName}-unwrapped";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/${filename}";
      sha256 = sha256Hash;
    };

    nativeBuildInputs = [
      unzip
      makeWrapper
    ];

    # Causes the shebangs in interpreter scripts deployed to mobile devices to be patched, which Android does not understand
    dontPatchShebangs = true;

    installPhase = ''
      cp -r . $out
      wrapProgram $out/bin/studio.sh \
        --set-default JAVA_HOME "$out/jbr" \
        --set ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        ${lib.optionalString tiling_wm "--set _JAVA_AWT_WM_NONREPARENTING 1"} \
        --set FONTCONFIG_FILE ${fontsConf} \
        --prefix PATH : "${lib.makeBinPath [

          # Checked in studio.sh
          coreutils
          findutils
          gnugrep
          which
          gnused

          # For Android emulator
          file
          glxinfo
          pciutils
          setxkbmap

          # Used during setup wizard
          gnutar
          gzip

          # Runtime stuff
          git
          ps
          usbutils
        ]}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [

          # Crash at startup without these
          fontconfig
          freetype
          libXext
          libXi
          libXrender
          libXtst

          # No crash, but attempted to load at startup
          e2fsprogs

          # Gradle wants libstdc++.so.6
          stdenv.cc.cc.lib
          # mksdcard wants 32 bit libstdc++.so.6
          pkgsi686Linux.stdenv.cc.cc.lib

          # aapt wants libz.so.1
          zlib
          pkgsi686Linux.zlib
          # Support multiple monitors
          libXrandr

          # For Android emulator
          alsa-lib
          dbus
          expat
          libpulseaudio
          libuuid
          libX11
          libxcb
          libXcomposite
          libXcursor
          libXdamage
          libXfixes
          libGL
          nspr
          nss_latest
          systemd

          # For GTKLookAndFeel
          gtk2
          gnome_vfs
          glib
          GConf
        ]}"

      # AS launches LLDBFrontend with a custom LD_LIBRARY_PATH
      wrapProgram $(find $out -name LLDBFrontend) --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        ncurses5
        zlib
      ]}"
    '';
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = "Android Studio (${channel} channel)";
    comment = "The official Android IDE";
    categories = [ "Development" "IDE" ];
    startupNotify = true;
    startupWMClass = "jetbrains-studio";
  };

  # Android Studio downloads prebuilt binaries as part of the SDK. These tools
  # (e.g. `mksdcard`) have `/lib/ld-linux.so.2` set as the interpreter. An FHS
  # environment is used as a work around for that.
  fhsEnv = buildFHSEnv {
    name = "${drvName}-fhs-env";
    multiPkgs = pkgs: [
      ncurses5

      # Flutter can only search for certs Fedora-way.
      (runCommand "fedoracert" {}
        ''
        mkdir -p $out/etc/pki/tls/
        ln -s ${cacert}/etc/ssl/certs $out/etc/pki/tls/certs
        '')
    ];
  };
in runCommand
  drvName
  {
    startScript = ''
      #!${bash}/bin/bash
      ${fhsEnv}/bin/${drvName}-fhs-env ${androidStudio}/bin/studio.sh "$@"
    '';
    preferLocalBuild = true;
    allowSubstitutes = false;
    passthru = {
      unwrapped = androidStudio;
    };
    meta = with lib; {
      description = "The Official IDE for Android (${channel} channel)";
      longDescription = ''
        Android Studio is the official IDE for Android app development, based on
        IntelliJ IDEA.
      '';
      homepage = if channel == "stable"
        then "https://developer.android.com/studio/index.html"
        else "https://developer.android.com/studio/preview/index.html";
      license = with licenses; [ asl20 unfree ]; # The code is under Apache-2.0, but:
      # If one selects Help -> Licenses in Android Studio, the dialog shows the following:
      # "Android Studio includes proprietary code subject to separate license,
      # including JetBrains CLion(R) (www.jetbrains.com/clion) and IntelliJ(R)
      # IDEA Community Edition (www.jetbrains.com/idea)."
      # Also: For actual development the Android SDK is required and the Google
      # binaries are also distributed as proprietary software (unlike the
      # source-code itself).
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; rec {
        stable = [ alapshin ];
        beta = [ alapshin ];
        canary = [ alapshin ];
        dev = canary;
      }."${channel}";
      mainProgram = pname;
    };
  }
  ''
    mkdir -p $out/{bin,share/pixmaps}

    echo -n "$startScript" > $out/bin/${pname}
    chmod +x $out/bin/${pname}

    ln -s ${androidStudio}/bin/studio.png $out/share/pixmaps/${pname}.png
    ln -s ${desktopItem}/share/applications $out/share/applications
  ''
