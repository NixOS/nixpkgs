{ stdenv, fetchurl, scons, pkgconfig, gtk, bzip2, libglade, openssl
, libX11, boost, zlib, libnotify }:

stdenv.mkDerivation rec {
  name = "ldcpp-1.1.0";
  src = fetchurl {
    url = http://launchpad.net/linuxdcpp/1.1/1.1.0/+download/linuxdcpp-1.1.0.tar.bz2;
    sha256 = "12i92hirmwryl1qy0n3jfrpziwzb82f61xca9jcjwyilx502f0b6";
  };
  buildInputs = [ scons pkgconfig gtk bzip2 libglade openssl libX11 boost libnotify ];

  installPhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lX11";

    touch gettext xgettext msgfmt msgcat
    chmod +x gettext xgettext msgfmt msgcat
    export PATH=$PATH:$PWD

    mkdir -p $out
    scons PREFIX=$out
    scons PREFIX=$out install
  '';

  meta = {
    description = "Direct Connect client";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
