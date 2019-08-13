{ stdenv, fetchurl, lib, makeWrapper,
  # build dependencies
  alsaLib, atk, cairo, cups, dbus, expat, fontconfig,
  freetype, gdk-pixbuf, glib, gnome2, nspr, nss, xorg,
  glibc, systemd
}:

stdenv.mkDerivation {

  version = "2.12.0";

  pname = "patchwork-classic";

  src = fetchurl {
    url    = "https://github.com/ssbc/patchwork-classic-electron/releases/download/v2.12.0/ssb-patchwork-electron_2.12.0_linux-amd64.deb";
    sha256 = "1rvp07cgqwv7ac319p0qwpfxd7l8f53m1rlvvig7qf7q23fnmbsj";
  };

  sourceRoot = ".";

  unpackCmd = ''
    ar p "$src" data.tar.xz | tar xJ
  '';

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -R usr/share opt $out/

    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/ssb-patchwork-electron.desktop \
      --replace /opt/ $out/opt/

    # symlink the binary to bin/
    ln -s $out/opt/ssb-patchwork-electron/ssb-patchwork-electron $out/bin/patchwork-classic
  '';


  preFixup = let
    packages = [
      alsaLib
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gnome2.GConf
      gnome2.gtk
      gnome2.pango
      nspr
      nss
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      stdenv.cc.cc.lib
      stdenv.cc.cc
      glibc
    ];
    libPathNative = lib.makeLibraryPath packages;
    libPath64 = lib.makeSearchPathOutput "lib" "lib64" packages;
    libPath = "${libPathNative}:${libPath64}";
  in ''
    # patch executable
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}:$out/opt/ssb-patchwork-electron" \
      $out/opt/ssb-patchwork-electron/ssb-patchwork-electron

    # patch libnode
    patchelf \
      --set-rpath "${libPath}" \
      $out/opt/ssb-patchwork-electron/libnode.so

    # libffmpeg is for some reason  not executable
    chmod a+x $out/opt/ssb-patchwork-electron/libffmpeg.so

    # fix missing libudev
    ln -s ${systemd.lib}/lib/libudev.so.1 $out/opt/ssb-patchwork-electron/libudev.so.1
    wrapProgram $out/opt/ssb-patchwork-electron/ssb-patchwork-electron \
      --prefix LD_LIBRARY_PATH : $out/opt/ssb-patchwork-electron
  '';

  meta = with stdenv.lib; {
    description = "Electron wrapper for Patchwork Classic: run as a desktop app outside the browser";
    homepage    = "https://github.com/ssbc/patchwork-classic-electron";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ mrVanDalo ];
    platforms   = platforms.linux;
  };
}
