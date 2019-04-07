{ channel, pname, version, build, sha256Hash }:

{ bash
, buildFHSUserEnv
, coreutils
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
, libX11
, libXext
, libXi
, libXrandr
, libXrender
, libXtst
, makeWrapper
, pciutils
, pkgsi686Linux
, setxkbmap
, stdenv
, unzip
, which
, runCommand
, xkeyboard_config
, zlib
, makeDesktopItem
}:

let
  drvName = "android-studio-${channel}-${version}";
  archiveFormat = if builtins.elem channel [ "dev" "canary" ] then "tar.gz" else "zip";
  androidStudio = stdenv.mkDerivation {
    name = drvName;

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.${archiveFormat}";
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
        --set PATH "${stdenv.lib.makeBinPath [

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
          libpulseaudio
          libX11
          libGL

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
    multiPkgs = pkgs: [ pkgs.ncurses5 ];
  };
in runCommand
  "${drvName}-wrapper"
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
        then https://developer.android.com/studio/index.html
        else https://developer.android.com/studio/preview/index.html;
      license = licenses.asl20;
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
