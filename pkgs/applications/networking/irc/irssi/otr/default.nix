{ stdenv, fetchFromGitHub, libotr, automake, autoconf, libtool, glib, pkgconfig, irssi }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "irssi-otr-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cryptodotis";
    repo = "irssi-otr";
    rev = "4ad3b7b6c85be0154ab3694fe9831796db20c4fe";
    sha256 = "1hm1whx1wzlx4fh4xf2y68rx9x6whi8bsbrhd6hqjhskg5msssrg";
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
