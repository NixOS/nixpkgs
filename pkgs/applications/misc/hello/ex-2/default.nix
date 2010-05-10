{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hello-2.6";
  
  src = fetchurl {
    url = "mirror://gnu/hello/${name}.tar.gz";
    sha256 = "1h6fjkkwr7kxv0rl5l61ya0b49imzfaspy7jk9jas1fil31sjykl";
  };

  doCheck = true;

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = http://www.gnu.org/software/hello/manual/;
    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
