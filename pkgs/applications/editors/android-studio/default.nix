{ bash
, buildFHSUserEnv
, coreutils
, fetchurl
, findutils
, git
, gnugrep
, gnutar
, gzip
, jdk
, libXrandr
, makeWrapper
, pkgsi686Linux
, stdenv
, unzip
, which
, writeTextFile
, zlib
}:

let

  version = "2.1.2.0";
  build = "143.2915827";

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

        # Used during setup wizard
        gnutar
        gzip

        # Runtime stuff
        git

      ]}" --set LD_LIBRARY_PATH "${stdenv.lib.makeLibraryPath [
        # Gradle wants libstdc++.so.6
        stdenv.cc.cc.lib
        # mksdcard wants 32 bit libstdc++.so.6
        pkgsi686Linux.stdenv.cc.cc.lib
        # aapt wants libz.so.1
        zlib
        pkgsi686Linux.zlib
        # Support multiple monitors
        libXrandr
      ]}"
    '';
    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "0q61m8yln77valg7y6lyxlml53z387zh6fyfgc22sm3br5ahbams";
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
