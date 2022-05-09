{ addOpenGLRunpath
, autoPatchelfHook
, callPackage
, lib
, lndir
, makeWrapper
, patchelf
, requireFile
, runCommand
, stdenv
# required packages
, alsa-lib
, coreutils
, cups
, dbus
, flite
, fontconfig
, freetype
, gcc
, gcc-unwrapped
, glib
, gmpxx
, keyutils
, libGL
, libGLU
, libpcap
, libtins
, libuuid
, libxkbcommon
, libxml2
, llvmPackages_12
, matio
, mpfr
, ncurses
, opencv2
, opencv4
, openjdk11
, openssl
, pciutils
, tre
, unixODBC
, xkeyboard_config
, xorg
, zlib
# settings and optional packages
, cudaSupport ? false
, cudaPackages ? null
, lang ? "en"
, version ? null
}:

let versions = import ./versions.nix { inherit lib requireFile; };

    matching-versions =
      with lib; sort compareVersions (filter
        (v: v.lang == lang
            && (if version == null then true else isMatching v.version version))
        versions);

    found-version =
      if matching-versions == []
      then throw ("No registered Mathematica version found to match"
                  + " version=${version} and language=${lang}")
      else lib.head matching-versions;

    drv-name = ./. + "/${lib.versions.major found-version.version}.nix";

    real-drv = if lib.pathExists drv-name then drv-name else ./generic.nix;

    isMatching = v1: v2:
      let as = lib.versions.splitVersion v1;
          bs = lib.versions.splitVersion v2;
          n  = lib.min (lib.length as) (lib.length bs);
      in lib.take n as == lib.take n bs;

    compareVersions = v1: v2:
      let a = lib.versions.major v1.version;
          b = lib.versions.major v2.version;
      in lib.toInt a > lib.toInt b;

in

import real-drv {

  inherit
    addOpenGLRunpath
    autoPatchelfHook
    callPackage
    lib
    lndir
    makeWrapper
    patchelf
    requireFile
    runCommand
    stdenv;

  inherit
    alsa-lib
    coreutils
    cups
    dbus
    flite
    fontconfig
    freetype
    gcc
    gcc-unwrapped
    glib
    gmpxx
    keyutils
    libGL
    libGLU
    libpcap
    libtins
    libuuid
    libxkbcommon
    libxml2
    llvmPackages_12
    matio
    mpfr
    ncurses
    opencv2
    opencv4
    openjdk11
    openssl
    pciutils
    tre
    unixODBC
    xkeyboard_config
    xorg
    zlib;

  inherit cudaSupport cudaPackages;

  inherit (found-version) version lang src;

  name = ("mathematica"
          + lib.optionalString cudaSupport "-cuda"
          + "-${found-version.version}"
          + lib.optionalString (lang != "en") "-${lang}");

  meta = with lib; {
    description = "Wolfram Mathematica computational software system";
    homepage = "http://www.wolfram.com/mathematica/";
    license = licenses.unfree;
    maintainers = with maintainers; [ herberteuler ];
    platforms = [ "x86_64-linux" ];
  };
}
