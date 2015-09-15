{ fetchurl, stdenv, dpkg, makeWrapper, xorg, qt5Full, gstreamer, zlib, sqlite, libxslt }:

assert stdenv.system == "x86_64-linux";

# BUG: viber tries to access contacts list and that causes segfault
# FIX: you have to do `chmod 444 ~/.ViberPC/<your mobile phone number>/Avatars`
# BUG: viber tries to it's downloads and that causes segfault
# FIX: you have to do `chmod 444 ~/Documents/ViberDownloads`
# TODO: fix bugs

stdenv.mkDerivation rec {
  name = "viber-${version}";
  version = "4.2.2.6";

  src = fetchurl {
    url = "http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
    sha256 = "1fv269z9sni21lc1ka25jnxr9w8zfg1gfn2c7fnd8cdd5fm57d26";
  };

  buildInputs = [ dpkg makeWrapper ];

  unpackPhase = "true";

  libPath = stdenv.lib.makeLibraryPath [
      qt5Full
      xorg.libX11
      gstreamer
      zlib
      sqlite
      xorg.libXrender
      libxslt
      stdenv.cc.cc
      xorg.libXScrnSaver
      xorg.libXext
  ];

  installPhase = ''
    dpkg-deb -x $src $out
    mkdir -p $out/bin
    mv $out/opt/viber/{Sound,icons,libqfacebook.so} $out
    mv $out/opt/viber/Viber $out/viber
    rm -rf $out/opt
    ln -s $out/viber $out/bin/viber
    mkdir -p usr/lib/mozilla/plugins

    patchelf \
      --set-rpath $libPath \
      $out/libqfacebook.so
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath:$out \
      $out/viber

    wrapProgram $out/viber --prefix LD_LIBRARY_PATH : $libPath:$out
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = http://www.viber.com;
    description = "An instant messaging and Voice over IP (VoIP) app";
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jagajaga ];
    broken = true;
  };

}
