{ pname, version, build, src, meta }:
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
  androidStudio = stdenv.mkDerivation {
    inherit src;
    name = "${pname}";
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
  };

  # Android Studio downloads prebuilt binaries as part of the SDK. These tools
  # (e.g. `mksdcard`) have `/lib/ld-linux.so.2` set as the interpreter. An FHS
  # environment is used as a work around for that.
  fhsEnv = buildFHSUserEnv {
    name = "${pname}-fhs-env";
  };

in
  writeTextFile {
    name = "${pname}-${version}";
    destination = "/bin/${pname}";
    executable = true;
    text = ''
      #!${bash}/bin/bash
      ${fhsEnv}/bin/${pname}-fhs-env ${androidStudio}/bin/studio.sh
    '';
  } // { inherit meta; }
