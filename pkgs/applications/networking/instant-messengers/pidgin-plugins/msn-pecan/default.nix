{ stdenv, fetchurl, pidgin} :

stdenv.mkDerivation {
  name = "pidgin-msn-pecan-0.1.4";
  src = fetchurl {
    url = http://msn-pecan.googlecode.com/files/msn-pecan-0.1.4.tar.bz2;
    sha256 = "0d43z2ay9is1r2kkc9my8pz0fwdyzv7k19vdmbird18lg7rlbjd2";
  };

  meta = {
    description = "Alternative MSN protocol plug-in for Pidgin IM";
    homepage = http://code.google.com/p/msn-pecan/;
    platforms = stdenv.lib.platforms.linux;
  };

  makeFlags = "PURPLE_LIBDIR=lib PURPLE_DATADIR=share/data DESTDIR=$$out";
  preInstall = "mkdir -p \$out/share";
  postInstall = "ln -s \$out/lib/purple-2 \$out/share/pidgin-msn-pecan";

  buildInputs = [pidgin];
}
