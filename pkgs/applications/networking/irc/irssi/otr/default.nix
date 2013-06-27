{ stdenv, fetchurl, libotr, automake, autoconf, libtool, glib, pkgconfig, irssi }:

let
  rev = "cab3fc915c";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "irssi-otr-20130601-${rev}";
  
  src = fetchurl {
    url = "https://github.com/cryptodotis/irssi-otr/tarball/${rev}";
    name = "${name}.tar.gz";
    sha256 = "0kn9c562zfh36gpcrbpslwjjr78baagdwphczz2d608ndczm1vrk";
  };

  patchPhase = ''
    sed -i 's,/usr/include/irssi,${irssi}/include/irssi,' src/Makefile.am
    sed -i "s,/usr/lib/irssi,$out/lib/irssi," configure.ac
    sed -i "s,/usr/share/irssi,$out/share/irssi," help/Makefile.am
  '';

  preConfigure = "sh ./bootstrap";

  buildInputs = [ libotr automake autoconf libtool glib pkgconfig irssi ];
  
  meta = {
    homepage = https://github.com/cryptodotis/irssi-otr;
    license = "GPLv2+";
  };
}
