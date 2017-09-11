{
  stdenv, fetchurl, dpkg, alsaLib, atk, cairo, cups, curl, dbus, expat,
  fontconfig, freetype, glib, gnome2, libnotify, nspr, nss, systemd, xorg
}:

with stdenv.lib;

let

  version = "2.0.6";

  rpath = makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    gnome2.GConf
    gnome2.gdk_pixbuf
    gnome2.gtk
    gnome2.pango
    libnotify
    nspr
    nss
    stdenv.cc.cc
    systemd

    xorg.libxkbfile
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/aluxian/Messenger-for-Desktop/releases/download/v2.0.6/messengerfordesktop-2.0.6-linux-amd64.deb";
        sha256 = "bf3f3ed9ac46ceb4b7dffbeb33c7d15bbcbfcdd141c4dbfbb620e8bfefae906b";
      }
    else
      throw "Messenger for Desktop is not supported on ${stdenv.system}";

in stdenv.mkDerivation {
  name = "messenger-for-desktop-${version}";

  inherit src;

  buildInputs = [ dpkg ];
  unpackPhase = "true";
  buildCommand = ''
    mkdir -p $out
    dpkg -x $src $out

    mv $out/usr/share $out/share
    mv $out/opt/messengerfordesktop $out/libexec
    rmdir $out/usr $out/opt

    chmod -R g-w $out

    # patch the binaries
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/libexec $file || true
    done

    # add symlink to bin
    mkdir -p $out/bin
    ln -s $out/libexec/messengerfordesktop $out/bin/messengerfordesktop

    # Fix the desktop link
    substituteInPlace $out/share/applications/messengerfordesktop.desktop                 \
      --replace /opt/messengerfordesktop/messengerfordesktop $out/bin/messengerfordesktop 
  '';

  meta = {
    description = "Bring messenger.com to your Linux desktop.";
    longDescription = ''
      A simple & beautiful desktop client for Facebook Messenger. Chat without
      distractions on macOS, Windows and Linux. Not affiliated with Facebook.
      This is NOT an official product.
    '';
    homepage = https://messengerfordesktop.org;
    license = licenses.mit;
    maintainers = [
      maintainers.shawndellysse
    ];
    platforms = [
      "x86_64-linux"
    ];
  };
}
