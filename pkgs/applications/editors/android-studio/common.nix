{ channel, pname, version, build, sha256Hash }:

{ alsaLib
, bash
, buildFHSUserEnv
, cacert
, coreutils
, dbus
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
, nspr
, nss
, pciutils
, pkgsi686Linux
, ps
, setxkbmap
, stdenv
, systemd
, unzip
, which
, runCommand
, xkeyboard_config
, zlib
, makeDesktopItem
}:

let
  drvName = "android-studio-${channel}-${version}";
  androidStudio = stdenv.mkDerivation {
    name = "${drvName}-unwrapped";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.tar.gz";
      sha256 = sha256Hash;
    };

    buildInputs = [
      makeWrapper
      unzip
    ];
    installPhase = ''
      cp -r . $out
      wrapProgram $out/bin/studio.sh \
        --set ANDROID_EMULATOR_USE_SYSTEM_LIBS 1 \
        --prefix PATH : "${stdenv.lib.makeBinPath [

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
        ]}" \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [

          # Crash at startup without these
          fontconfig
          freetype
          libXext
          libXi
          libXrender
          libXtst

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
          alsaLib
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
          nss
          systemd

          # For GTKLookAndFeel
          gtk2
          gnome_vfs
          glib
          GConf
        ]}" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set FONTCONFIG_FILE ${fontsConf}
    '';
  };

  desktopItem = makeDesktopItem {
    name = drvName;
    exec = pname;
    icon = drvName;
    desktopName = "Android Studio (${channel} channel)";
    comment = "The official Android IDE";
    categories = "Development;IDE;";
    startupNotify = "true";
    extraEntries="StartupWMClass=jetbrains-studio";
  };

  # Android Studio downloads prebuilt binaries as part of the SDK. These tools
  # (e.g. `mksdcard`) have `/lib/ld-linux.so.2` set as the interpreter. An FHS
  # environment is used as a work around for that.
  fhsEnv = buildFHSUserEnv {
    name = "${drvName}-fhs-env";
    multiPkgs = pkgs: [
      pkgs.ncurses5

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
      ${fhsEnv}/bin/${drvName}-fhs-env ${androidStudio}/bin/studio.sh
    '';
    preferLocalBuild = true;
    allowSubstitutes = false;
    passthru = {
      unwrapped = androidStudio;
    };
    meta = with stdenv.lib; {
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
      maintainers = with maintainers; [ primeos ];
    };
  }
  ''
    mkdir -p $out/{bin,share/pixmaps}

    echo -n "$startScript" > $out/bin/${pname}
    chmod +x $out/bin/${pname}

    ln -s ${androidStudio}/bin/studio.png $out/share/pixmaps/${drvName}.png
    ln -s ${desktopItem}/share/applications $out/share/applications
  ''
