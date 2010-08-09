{ stdenv, fetchurl, pidgin} :

stdenv.mkDerivation {
  name = "pidgin-msn-pecan-0.1.0";
  src = fetchurl {
    url = http://msn-pecan.googlecode.com/files/msn-pecan-0.1.0.tar.bz2;
    sha256 = "06cgkdlv2brv2g5hpx8g8p6j296cnvd29l8fap30i1k0mznbjxf4";
  };

  meta = {
    description = "Alternative MSN protocol plug-in for Pidgin IM.";
    homepage = http://code.google.com/p/msn-pecan/;
  };

  makeFlags = "PURPLE_LIBDIR=lib PURPLE_DATADIR=share/data DESTDIR=$$out";
  preInstall = "ensureDir \$out/share";
  postInstall = "ln -s \$out/lib/purple-2 \$out/share/pidgin-msn-pecan";

  buildInputs = [pidgin];
}
