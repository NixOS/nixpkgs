{ stdenv, fetchipfs }:

stdenv.mkDerivation rec {
  name = "hello-2.10";

  src = fetchipfs {
    url    = "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz";
    ipfs   = "QmWyj65ak3wd8kG2EvPCXKd6Tij15m4SwJz6g2yG2rQ7w8";
    sha256 = "1im1gglfm4k10bh4mdaqzmx3lm3kivnsmxrvl6vyvmfqqzljq75l";
  };

  doCheck = true;

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
