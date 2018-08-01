{ channel, pname, version, build, sha256Hash, deprecated ? false }:

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
, writeTextFile
, xkeyboard_config
, zlib
}:

let
  # TODO: This is a bit stupid to be honest...
  # The problem is that we have to make sure this is only executed if the
  # derivation is actually build to avoid always printing this warning (e.g.
  # "nix-env -qaP"). Since this will always evaluate to "" it won't actually
  # change the derivation (only generate a side-effect) but we have to make
  # sure this expression is evaluated lazily!
  printDeprecationWarning = if deprecated then (builtins.trace ''
    android-studio-preview and androidStudioPackages.preview are old aliases
    and will be dropped at some point, please use androidStudioPackages.beta
    instead (corresponds to the correct channel name).''
    "")
    else "";
  drvName = "android-studio-${channel}-${version}";
  androidStudio = stdenv.mkDerivation {
    name = drvName;

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
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

  # Android Studio downloads prebuilt binaries as part of the SDK. These tools
  # (e.g. `mksdcard`) have `/lib/ld-linux.so.2` set as the interpreter. An FHS
  # environment is used as a work around for that.
  fhsEnv = buildFHSUserEnv {
    name = "${drvName}-fhs-env";
    multiPkgs = pkgs: [ pkgs.ncurses5 ];
  };

in
  writeTextFile {
    name = "${drvName}-wrapper";
    # TODO: Rename preview -> beta (and add -stable suffix?):
    destination = "/bin/${pname}";
    executable = true;
    text = ''
      #!${bash}/bin/bash
      ${fhsEnv}/bin/${drvName}-fhs-env ${androidStudio}/bin/studio.sh
    '' + printDeprecationWarning;
  } // {
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
