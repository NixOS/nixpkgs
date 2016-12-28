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
, jdk
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
}:

let

  version = "2.2.3.0";
  build = "145.3537739";

  androidStudio = stdenv.mkDerivation {
    name = "android-studio";
    buildInputs = [
      makeWrapper
      unzip
    ];
    installPhase = ''
      cp -r . $out
      wrapProgram $out/bin/studio.sh --set PATH "${stdenv.lib.makeBinPath [

        # Checked in studio.sh
        coreutils
        findutils
        gnugrep
        jdk
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

      ]}" --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [
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
        libXext
        libXrender
        libXtst
        libXi
        freetype
        fontconfig
      ]}" --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb"
    '';
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "10fmffkvvbnmgjxb4rq7rjwnn16jp5phw6div4n7hh2ad6spf8wq";
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
