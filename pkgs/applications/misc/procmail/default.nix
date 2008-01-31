args: with args;
stdenv.mkDerivation {
  name="procmail-3.22";
  patchPhase = "find . -type f | xargs sed -i 's@/bin/rm@rm@g' ";
  configurePhase= "make init";
  makeFlags = ''BASENAME=$(out) LIBS=-lm'';

  postInstall = '' sed -i /^PATH/d $out/bin/mailstat '';
  src = fetchurl {
    url = ftp://ftp.fu-berlin.de/pub/unix/mail/procmail/procmail-3.22.tar.gz;
    sha256 = "05z1c803n5cppkcq99vkyd5myff904lf9sdgynfqngfk9nrpaz08";
  };
}
