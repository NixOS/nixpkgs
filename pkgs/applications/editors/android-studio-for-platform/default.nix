{ bash
, buildFHSEnv
, cacert
, coreutils
, dpkg
, e2fsprogs
, fetchurl
, findutils
, git
, gnugrep
, gnused
, gnutar
, gtk2, gnome_vfs, glib, GConf
, gzip
, fontconfig
, freetype
, libX11
, libXext
, libXi
, libXrandr
, libXrender
, libXtst
, makeFontsConf
, makeWrapper
, ncurses5
, openssl
, pkgsi686Linux
, ps
, python3
, lib
, stdenv
, unzip
, usbutils
, which
, runCommand
, xkeyboard_config
, zip
, zlib
, makeDesktopItem
, tiling_wm ? false # if we are using a tiling wm, need to set _JAVA_AWT_WM_NONREPARENTING in wrapper
}:

let
  pname = "android-studio-for-platform";
  version = "2023.1.1.19";

  drvName = "android-studio-for-platform-${version}";
  filename = "asfp-${version}-linux.deb";

  fontsConf = makeFontsConf {
    fontDirectories = [];
  };

  androidStudioForPlatform = stdenv.mkDerivation {
    name = "${drvName}-unwrapped";

    src = fetchurl {
      url = "https://dl.google.com/android/asfp/${filename}";
      sha256 = "e4fa09fa5df9cbae249d69a3d92ef0d121b7b5c6628baff9558c66e3ae0ca0a4";
    };

    nativeBuildInputs = [
      dpkg
      unzip
      makeWrapper
    ];

    dontUnpack = true;

    # Causes the shebangs in interpreter scripts deployed to mobile devices to be patched, which Android does not understand
    dontPatchShebangs = true;

    installPhase = ''
      dpkg -x $src .
      cp -r ./opt/android-studio-for-platform/ $out
      wrapProgram $out/bin/studio.sh \
        --set-default JAVA_HOME "$out/jbr" \
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

          # Used during setup wizard
          gnutar
          gzip

          # Runtime stuff
          git
          ps
          usbutils

          # For Soong sync
          openssl
          python3
          unzip
          zip
        ]}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [

          # Crash at startup without these
          fontconfig
          freetype
          libXext
          libXi
          libXrender
          libXtst
          libX11

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
    desktopName = "Android Studio for Platform";
    comment = "The official Android IDE for Android platform development";
    categories = [ "Development" "IDE" ];
    startupNotify = true;
    startupWMClass = "jetbrains-studio";
  };

  # Android Studio for Platform downloads prebuilt binaries as part of the SDK. These tools
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
      ${fhsEnv}/bin/${drvName}-fhs-env ${androidStudioForPlatform}/bin/studio.sh "$@"
    '';
    preferLocalBuild = true;
    allowSubstitutes = false;
    passthru = {
      unwrapped = androidStudioForPlatform;
    };
    meta = with lib; {
      description = "The Official IDE for Android platform development";
      longDescription = ''
        Android Studio for Platform (ASfP) is the version of the Android Studio IDE
        for Android Open Source Project (AOSP) platform developers who build with the Soong build system.
      '';
      homepage = "https://developer.android.com/studio/platform.html";
      license = with licenses; [ asl20 unfree ]; # The code is under Apache-2.0, but:
      # If one selects Help -> Licenses in Android Studio, the dialog shows the following:
      # "Android Studio includes proprietary code subject to separate license,
      # including JetBrains CLion(R) (www.jetbrains.com/clion) and IntelliJ(R)
      # IDEA Community Edition (www.jetbrains.com/idea)."
      # Also: For actual development the Android SDK is required and the Google
      # binaries are also distributed as proprietary software (unlike the
      # source-code itself).
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ robbins ];
      mainProgram = pname;
    };
  }
  ''
    mkdir -p $out/{bin,share/pixmaps}

    echo -n "$startScript" > $out/bin/${pname}
    chmod +x $out/bin/${pname}

    ln -s ${androidStudioForPlatform}/bin/studio.png $out/share/pixmaps/${pname}.png
    ln -s ${desktopItem}/share/applications $out/share/applications
  ''
