{ stdenv, fetchurl, libotr, automake, autoconf, libtool, glib, pkgconfig, irssi }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "irssi-otr-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/cryptodotis/irssi-otr/archive/v${version}.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "bad09a2853ea6fb1a7af42c8f15868fd3ce45f973be90c78944ddf04f8ab517e";
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
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
