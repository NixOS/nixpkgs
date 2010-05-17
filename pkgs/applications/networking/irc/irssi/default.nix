{stdenv, fetchurl, pkgconfig, ncurses, glib, openssl, perl}:

stdenv.mkDerivation rec {
  name = "irssi-0.8.15";
  
  src = fetchurl {
    url = "http://irssi.org/files/${name}.tar.bz2";
    sha256 = "19m0aah9bhc70dnhh7kpydbsz5n35l0l9knxav1df0sic3xicbf1";
  };
  
  buildInputs = [pkgconfig ncurses glib openssl perl];
  
  NIX_LDFLAGS = "-lncurses";
  
  configureFlags = "--with-proxy --with-ncurses --enable-ssl --with-perl=yes";

  meta = {
    homepage = http://irssi.org;
  };
}
