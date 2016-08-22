{ stdenv, fetchipfs }:

stdenv.mkDerivation rec {
  name = "hello-2.10";

  src = fetchipfs {
    url    = "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz";
    ipfs   = "QmeWBgpeMSNV9Mvp85N7jyFxbhUpgySANJsef5XQYyykjd";
    sha256 = "0lbgr8d2vhblhczc16llcrvid6v7s678733zac6jbm6gy2di1mjb";
    execs  = [ "configure" ];
  };

  doCheck = false;

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = http://www.gnu.org/software/hello/manual/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
