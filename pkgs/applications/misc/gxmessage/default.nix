{ stdenv, fetchurl, gtk3, intltool, pkgconfig, texinfo }:

stdenv.mkDerivation rec {
  pname = "gxmessage";
  version = "3.4.3";

  src = fetchurl {
    url = "http://homepages.ihug.co.nz/~trmusson/stuff/${pname}-${version}.tar.gz";
    sha256 = "db4e1655fc58f31e5770a17dfca4e6c89028ad8b2c8e043febc87a0beedeef05";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gtk3 texinfo ];

  meta = {
    description = "A GTK enabled dropin replacement for xmessage";
    homepage = "http://homepages.ihug.co.nz/~trmusson/programs.html#gxmessage";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [jfb];
    platforms = with stdenv.lib.platforms; linux;
  };
}
