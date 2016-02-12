{ stdenv, fetchFromGitHub, libotr, automake, autoconf, libtool, glib, pkgconfig, irssi }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "irssi-otr-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "cryptodotis";
    repo = "irssi-otr";
    rev = "v${version}";
    sha256 = "139jawz3la6k91fy5kpgr6zvljl14n0fdpz72n2zw6wql69xlnnl";
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
