{ stdenv, fetchurl, irssi, gmp, automake, autoconf, libtool, openssl, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fish-irssi-20130413-e98156bebd";
  
  src = fetchurl {
    url = https://github.com/falsovsky/FiSH-irssi/tarball/e98156bebd;
    name = "${name}.tar.gz";
    sha256 = "1ndr51qrg66h1mfzacwzl1vd6lj39pdc4p4z5iihrj4r2f6gk11a";
  };

  preConfigure = ''
    tar xf ${irssi.src}
    configureFlags="$configureFlags --with-irssi-source=`pwd`/${irssi.name}"

    ./regen.sh
  '';

  installPhase = ''
    mkdir -p $out/lib/irssi/modules
    cp src/.libs/libfish.so $out/lib/irssi/modules
  '';
  
  buildInputs = [ gmp automake autoconf libtool openssl glib pkgconfig ];
  
  meta = {
    homepage = https://github.com/falsovsky/FiSH-irssi;
    license = stdenv.lib.licenses.unfree; # I can't find any mention of license
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
