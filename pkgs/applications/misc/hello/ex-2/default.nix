{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hello-2.5";
  
  src = fetchurl {
    url = "mirror://gnu/hello/${name}.tar.gz";
    sha256 = "0in467phypnis2ify1gkmvc5l2fxyz3s4xss7g74gwk279ylm4r2";
  };

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = http://www.gnu.org/software/hello/manual/;
    license = "GPLv3+";
  };
}
