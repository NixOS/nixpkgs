{ alsaLib
, atk
, cairo
, cups
, curl
, dbus
, dpkg
, expat
, fetchurl
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gnome2
, gtk3
, libX11
, libxcb
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libnotify
, libpulseaudio
, libuuid
, nspr
, nss
, pango
, stdenv
, systemd
, at-spi2-atk
, at-spi2-core
}:

let

  mirror = https://get.geo.opera.com/pub/opera/desktop;
  version = "60.0.3255.109";

  rpath = stdenv.lib.makeLibraryPath [

    # These provide shared libraries loaded when starting. If one is missing,
    # an error is shown in stderr.
    alsaLib.out
    atk.out
    cairo.out
    cups
    curl.out
    dbus.lib
    expat.out
    fontconfig.lib
    freetype.out
    gdk_pixbuf.out
    glib.out
    gnome2.GConf
    gtk3.out
    libX11.out
    libXScrnSaver.out
    libXcomposite.out
    libXcursor.out
    libXdamage.out
    libXext.out
    libXfixes.out
    libXi.out
    libXrandr.out
    libXrender.out
    libXtst.out
    libxcb.out
    libnotify.out
    libuuid.out
    nspr.out
    nss.out
    pango.out
    stdenv.cc.cc.lib

    # This is a little tricky. Without it the app starts then crashes. Then it
    # brings up the crash report, which also crashes. `strace -f` hints at a
    # missing libudev.so.0.
    systemd.lib

    # Works fine without this except there is no sound.
    libpulseaudio.out

    at-spi2-atk
    at-spi2-core
  ];

in stdenv.mkDerivation {

  name = "opera-${version}";

  src = fetchurl {
    url = "${mirror}/${version}/linux/opera-stable_${version}_amd64.deb";
    sha256 = "0y3cjjzp41pa15sw8bp7n5ab8j8b1kk5h11b4pl6w8spsyk2cpqh";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  installPhase = ''
    mkdir --parent $out
    mv * $out/
    mv $out/lib/*/opera/*.so $out/lib/
  '';

  postFixup = ''
    find $out -executable -type f \
    | while read f
      do
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "$out/lib:${rpath}" \
          "$f"
      done
  '';

  meta = {
    homepage = https://www.opera.com;
    description = "Web browser";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.unfree;
  };
}
