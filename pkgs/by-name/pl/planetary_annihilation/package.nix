{
  lib,
  stdenv,
  patchelf,
  makeWrapper,
  gtk2,
  glib,
  udev,
  alsa-lib,
  atk,
  nspr,
  fontconfig,
  cairo,
  pango,
  nss,
  freetype,
  gnome2,
  gdk-pixbuf,
  curl,
  systemd,
  libxrender,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  requireFile,
}:

stdenv.mkDerivation rec {
  pname = "planetary-annihalation";
  version = "62857";

  src = requireFile {
    message = "This file has to be downloaded manually via nix-prefetch-url.";
    name = "PA_Linux_${version}.tar.bz2";
    sha256 = "0imi3k5144dsn3ka9khx3dj76klkw46ga7m6rddqjk4yslwabh3k";
  };

  nativeBuildInputs = [
    patchelf
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}

    cp -R * $out/
    mv $out/*.so $out/lib
    ln -s $out/PA $out/bin/PA

    ln -s ${systemd}/lib/libudev.so.1 $out/lib/libudev.so.0

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$out/PA"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${
      lib.makeLibraryPath [
        stdenv.cc.cc
        libxdamage
        libxfixes
        gtk2
        glib
        stdenv.cc.libc
        "$out"
        libxext
        pango
        udev
        libx11
        libxcomposite
        alsa-lib
        atk
        nspr
        fontconfig
        cairo
        pango
        nss
        freetype
        gnome2.GConf
        gdk-pixbuf
        libxrender
      ]
    }:${lib.getLib stdenv.cc.cc}/lib64:${stdenv.cc.libc}/lib64" "$out/host/CoherentUI_Host"

    wrapProgram $out/PA --prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        stdenv.cc.cc
        stdenv.cc.libc
        libx11
        libxcursor
        gtk2
        glib
        curl
        "$out"
      ]
    }:${lib.getLib stdenv.cc.cc}/lib64:${stdenv.cc.libc}/lib64"

    for f in $out/lib/*; do
      patchelf --set-rpath "${
        lib.makeLibraryPath [
          stdenv.cc.cc
          curl
          libx11
          stdenv.cc.libc
          libxcursor
          "$out"
        ]
      }:${lib.getLib stdenv.cc.cc}/lib64:${stdenv.cc.libc}/lib64" $f
    done
  '';

  meta = {
    homepage = "http://www.uberent.com/pa/";
    description = "Next-generation RTS that takes the genre to a planetary scale";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
