{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "procmail-3.22";

  patches = [ ./CVE-2014-3618.patch ];

  # getline is defined differently in glibc now. So rename it.
  postPatch = ''
    sed -e "s%^RM.*$%#%" -i Makefile
    sed -e "s%^BASENAME.*%\BASENAME=$out%" -i Makefile
    sed -e "s%^LIBS=.*%LIBS=-lm%" -i Makefile
    sed -e "s%getline%thisgetline%g" -i src/*.c src/*.h
  '';

  src = fetchurl {
    url = ftp://ftp.fu-berlin.de/pub/unix/mail/procmail/procmail-3.22.tar.gz;
    sha256 = "05z1c803n5cppkcq99vkyd5myff904lf9sdgynfqngfk9nrpaz08";
  };

  meta = with stdenv.lib; {
    description = "Mail processing and filtering utility";
    homepage = http://www.procmail.org/;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
