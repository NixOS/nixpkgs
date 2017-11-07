{ stdenv, fetchurl, dpkg, gnome2, atk, cairo, gdk_pixbuf, glib, freetype,
fontconfig, dbus, libX11, xlibs, libXi, libXcursor, libXdamage, libXrandr,
libXcomposite, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss,
nspr, alsaLib, cups, expat, udev }:

stdenv.mkDerivation rec {
  pname = "signal-desktop";
  version = "1.0.35";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
    sha256 = "0q0q9k253f20qmnvclry665hha3qjpzz076zxb4fy8a19zax9yfr";
  };

  phases = [ "unpackPhase" "installPhase" ];
  buildInputs = [ dpkg ];
  unpackPhase = "dpkg-deb -x $src .";

  libPath = stdenv.lib.makeLibraryPath [
    gnome2.gtk gnome2.pango atk cairo gdk_pixbuf glib freetype fontconfig dbus
    libX11 xlibs.libxcb libXi libXcursor libXdamage libXrandr libXcomposite
    libXext libXfixes libXrender libXtst libXScrnSaver gnome2.GConf nss nspr
    alsaLib cups expat stdenv.cc.cc udev
  ];

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath "$out/opt/Signal:$libPath" opt/Signal/signal-desktop
    mkdir -p $out/bin
    cp -r opt $out
    ln -s $out/opt/Signal/signal-desktop $out/bin
    cp -r usr/share $out
    substituteInPlace $out/share/applications/signal-desktop.desktop \
      --replace Exec=\"/opt/Signal/signal-desktop\" Exec=signal-desktop
  '';

  meta = with stdenv.lib; {
    description = "Signal Private Messenger for the Desktop";
    homepage = https://signal.org/;
    downloadPage = "https://github.com/WhisperSystems/Signal-Desktop";
    license = licenses.gpl3;
    maintainers = [ maintainers.nickhu ];
    platforms = [ "x86_64-linux" ];
  };
}
