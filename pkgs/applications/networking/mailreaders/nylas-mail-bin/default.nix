{ dpkg, fetchurl, lib, pkgs, stdenv, config
, alsaLib
, atk
, cairo
, coreutils
, cups
, dbus
, desktop-file-utils
, expat
, fontconfig
, freetype
, gcc-unwrapped
, gdk_pixbuf
, glib
, gnome2
, libgcrypt
, libgnome-keyring
, libnotify
, makeWrapper
, nodejs
, nspr
, nss
, pango
, python2
, udev
, wget
, xorg
}:

stdenv.mkDerivation rec {
  name = "${pkgname}-${version}";
  pkgname = "nylas-mail-bin";
  version = "2.0.32";
  subVersion = "fec7941";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://edgehill.s3.amazonaws.com/${version}-${subVersion}/linux-deb/x64/NylasMail.deb";
        sha256 = "40060aa1dc3b5187b8ed4a07b9de3427e3c5a291df98c2c82395647fa2aa4ada";
      }
    else
      throw "NylasMail is not supported on ${stdenv.system}";

  propagatedBuildInputs = [
    alsaLib
    atk
    cairo
    coreutils
    cups
    dbus
    desktop-file-utils
    expat
    fontconfig
    freetype
    gcc-unwrapped
    gdk_pixbuf
    glib
    gnome2.GConf
    gnome2.gtk
    libgnome-keyring
    libnotify
    nodejs
    nspr
    nss
    pango
    python2
    udev
    wget
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
    xorg.libxkbfile
  ];


  buildInputs = [ gnome2.gnome-keyring ];

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out

    ${dpkg}/bin/dpkg-deb -x $src unpacked
    mv unpacked/usr/* $out/

    # Fix path in desktop file
    substituteInPlace $out/share/applications/nylas-mail.desktop \
      --replace /usr/bin/nylas-mail $out/bin/nylas-mail

    # Patch librariess
    noderp=$(patchelf --print-rpath $out/share/nylas-mail/libnode.so)
    patchelf --set-rpath $noderp:$out/lib:${stdenv.cc.cc.lib}/lib:${xorg.libxkbfile.out}/lib:${lib.makeLibraryPath propagatedBuildInputs } \
      $out/share/nylas-mail/libnode.so

    ffrp=$(patchelf --print-rpath $out/share/nylas-mail/libffmpeg.so)
    patchelf --set-rpath $ffrp:$out/lib:${stdenv.cc.cc.lib}/lib:${lib.makeLibraryPath propagatedBuildInputs } \
      $out/share/nylas-mail/libffmpeg.so

    # Patch binaries
    binrp=$(patchelf --print-rpath $out/share/nylas-mail/nylas)
    patchelf --interpreter $(cat "$NIX_CC"/nix-support/dynamic-linker) \
      --set-rpath $binrp:$out/lib:${stdenv.cc.cc.lib}/lib:${lib.makeLibraryPath propagatedBuildInputs } \
      $out/share/nylas-mail/nylas

    wrapProgram $out/share/nylas-mail/nylas --set LD_LIBRARY_PATH "${xorg.libxkbfile}/lib:${pkgs.gnome3.libgnome-keyring}/lib";

    # Fix path to bash so apm can install plugins.
    substituteInPlace $out/share/nylas-mail/resources/apm/bin/apm \
      --replace /bin/bash ${stdenv.shell}

    wrapProgram $out/share/nylas-mail/resources/apm/bin/apm \
      --set PATH "${coreutils}/bin"
    patchelf --interpreter $(cat "$NIX_CC"/nix-support/dynamic-linker) \
      --set-rpath ${gcc-unwrapped.lib}/lib $out/share/nylas-mail/resources/apm/bin/node
  '';

  meta = with stdenv.lib; {
    description = "Open-source mail client built on the modern web with Electron, React, and Flux";
    longDescription = ''
      Nylas Mail is an open-source mail client built on the modern web with Electron, React, and Flux. It is designed to be extensible, so it's easy to create new experiences and workflows around email. Nylas Mail can be enabled with it's requirements by enabling 'services.nylas-mail.enable=true'. Alternatively, make sure to have services.gnome3.gnome-keyring.enable = true; in your configuration.nix before running nylas-mail. If you happen to miss this step, you should remove ~/.nylas-mail and "~/.config/Nylas Mail" for a blank setup".
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ johnramsden ];
    homepage = https://nylas.com;
    platforms = [ "x86_64-linux" ];
  };
}
