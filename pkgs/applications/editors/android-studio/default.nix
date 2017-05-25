{ bash
, buildFHSUserEnv
, coreutils
, fetchurl
, findutils
, file
, git
, glxinfo
, gnugrep
, gnutar
, gzip
, fontconfig
, freetype
, libpulseaudio
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
, fontsConf
}:

let

  version = "2.3.2.0";
  build = "162.3934792";

  androidStudio = stdenv.mkDerivation {
    name = "android-studio";
    buildInputs = [
      makeWrapper
      unzip
    ];
    installPhase = ''
      cp -r . $out
      wrapProgram $out/bin/studio.sh \
        --set PATH "${stdenv.lib.makeBinPath [

          # Checked in studio.sh
          coreutils
          findutils
          gnugrep
          which

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

        ]}" \
        --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
        --set FONTCONFIG_FILE ${fontsConf}
    '';
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "19wmbvmiqa9znvnslmp0xmkq4avpmgpzmyaai1fa28388qra4cvf";
    };
    meta = {
      description = "The Official IDE for Android";
      homepage = https://developer.android.com/studio/index.html;
      license = stdenv.lib.licenses.asl20;
      platforms = [ "x86_64-linux" ];
    };
  };

  # Android Studio downloads prebuilt binaries as part of the SDK. These tools
  # (e.g. `mksdcard`) have `/lib/ld-linux.so.2` set as the interpreter. An FHS
  # environment is used as a work around for that.
  fhsEnv = buildFHSUserEnv {
    name = "android-studio-fhs-env";
  };

in writeTextFile {
  name = "android-studio-${version}";
  destination = "/bin/android-studio";
  executable = true;
  text = ''
    #!${bash}/bin/bash
    ${fhsEnv}/bin/android-studio-fhs-env ${androidStudio}/bin/studio.sh
  '';
}
