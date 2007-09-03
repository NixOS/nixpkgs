args: with args; stdenv.mkDerivation {
  name="procmail-3.22";
  buildInputs = [stdenv.gcc.libc];
  installPhase = "
    ensureDir \$out/bin
    find . -exec sed -e \"s%^RM[ \\t]*=%RM=`type -f rm | awk '{print $3;}'`%\" -i '{}' ';'
    sed -e 's%\\(LDFLAGS = \$(LDFLAGS1) -lnsl -ldl -lc\\)%\\1 -m%' -i src/Makefile
    sed -e \"s%^BASENAME.*%\BASENAME=$out%\" -i Makefile
    make DESTDIR=\$out install
   ";
  phases ="installPhase";
  src = fetchurl {
    url = ftp://ftp.fu-berlin.de/pub/unix/mail/procmail/procmail-3.22.tar.gz;
    sha256 = "05z1c803n5cppkcq99vkyd5myff904lf9sdgynfqngfk9nrpaz08";
  };
  o=62;
}
