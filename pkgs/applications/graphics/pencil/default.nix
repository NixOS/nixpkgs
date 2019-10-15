{ stdenv, fetchurl, lib, makeWrapper,
  # build dependencies
  alsaLib, atk, cairo, cups, dbus, expat, fontconfig,
  freetype, gdk-pixbuf, glib, gnome2, nspr, nss, xorg,
  glibc, systemd
}:

stdenv.mkDerivation rec {
  version = "3.0.4";
  pname = "pencil";

  src = fetchurl {
    url    = "http://pencil.evolus.vn/dl/V${version}/Pencil_${version}_amd64.deb";
    sha256 = "58e2b794c615ea8715d8374f177e19c87f7071e359826ec34a59836d537a62fd";
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
      $out/share/applications/pencil.desktop \
      --replace /opt/ $out/opt/

    # symlink the binary to bin/
    ln -s $out/opt/Pencil/pencil $out/bin/pencil
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
      --set-rpath "${libPath}:$out/opt/Pencil" \
      $out/opt/Pencil/pencil

    # patch libnode
    patchelf \
      --set-rpath "${libPath}" \
      $out/opt/Pencil/libnode.so

    # libffmpeg is for some reason  not executable
    chmod a+x $out/opt/Pencil/libffmpeg.so

    # fix missing libudev
    ln -s ${systemd.lib}/lib/libudev.so.1 $out/opt/Pencil/libudev.so.1
    wrapProgram $out/opt/Pencil/pencil \
      --prefix LD_LIBRARY_PATH : $out/opt/Pencil
  '';

  meta = with stdenv.lib; {
    description = "GUI prototyping/mockup tool";
    homepage    = "https://pencil.evolus.vn/";
    license     = licenses.gpl2; # Commercial license is also available
    maintainers = with maintainers; [ bjornfor prikhi mrVanDalo ];
    platforms   = platforms.linux;
  };
}
