{ lib, stdenv, fetchurl, libglade, gtk2, guile, libxml2, perl
, intltool, libtool, pkg-config }:

stdenv.mkDerivation rec {
  pname = "drgeo";
  version = "1.1.0";

  hardeningDisable = [ "format" ];

  src = fetchurl {
    url = "mirror://sourceforge/ofset/${pname}-${version}.tar.gz";
    sha256 = "05i2czgzhpzi80xxghinvkyqx4ym0gm9f38fz53idjhigiivp4wc";
  };
  patches = [ ./struct.patch ];

  buildInputs = [libglade gtk2 guile libxml2
    perl intltool libtool pkg-config];

  prebuild = ''
    cp drgeo.desktop.in drgeo.desktop
  '';

  meta = with lib; {
    description = "Interactive geometry program";
    homepage = "https://sourceforge.net/projects/ofset";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
