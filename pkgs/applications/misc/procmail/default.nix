args: with args;
stdenv.mkDerivation {
  name="procmail-3.22";

  buildInputs = [ stdenv.gcc.libc ];

  installPhase = "
    ensureDir \$out/bin
    sed -e \"s%^RM.*$%RM=`type -f rm | awk '{print $3;}'` -f%\" -i Makefile
    sed -e \"s%^BASENAME.*%\BASENAME=$out%\" -i Makefile
    sed -e \"s%^LIBS=.*%LIBS=-lm%\" -i Makefile
    make DESTDIR=\$out install
   ";

  phases = "unpackPhase installPhase";

  src = fetchurl {
    url = ftp://ftp.fu-berlin.de/pub/unix/mail/procmail/procmail-3.22.tar.gz;
    sha256 = "05z1c803n5cppkcq99vkyd5myff904lf9sdgynfqngfk9nrpaz08";
  };
}
