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
  xorg,
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
        xorg.libXdamage
        xorg.libXfixes
        gtk2
        glib
        stdenv.cc.libc
        "$out"
        xorg.libXext
        pango
        udev
        xorg.libX11
        xorg.libXcomposite
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
        xorg.libXrender
      ]
    }:${lib.getLib stdenv.cc.cc}/lib64:${stdenv.cc.libc}/lib64" "$out/host/CoherentUI_Host"

    wrapProgram $out/PA --prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        stdenv.cc.cc
        stdenv.cc.libc
        xorg.libX11
        xorg.libXcursor
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
          xorg.libX11
          stdenv.cc.libc
          xorg.libXcursor
          "$out"
        ]
      }:${lib.getLib stdenv.cc.cc}/lib64:${stdenv.cc.libc}/lib64" $f
    done
  '';

  meta = with lib; {
    homepage = "http://www.uberent.com/pa/";
    description = "Next-generation RTS that takes the genre to a planetary scale";
    license = lib.licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
