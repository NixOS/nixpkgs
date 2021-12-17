{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "procmail";
  version = "3.22";

  src = fetchurl {
    url = "ftp://ftp.fu-berlin.de/pub/unix/mail/procmail/procmail-${version}.tar.gz";
    sha256 = "05z1c803n5cppkcq99vkyd5myff904lf9sdgynfqngfk9nrpaz08";
  };

  patches = [
    ./CVE-2014-3618.patch
    (fetchurl {
      url = "https://sources.debian.org/data/main/p/procmail/3.22-26/debian/patches/30";
      sha256 = "11zmz1bj0v9pay3ldmyyg7473b80h89gycrhndsgg9q50yhcqaaq";
      name = "CVE-2017-16844";
    })
  ];

  # getline is defined differently in glibc now. So rename it.
  # Without the .PHONY target "make install" won't install anything on Darwin.
  postPatch = ''
    sed -i Makefile \
      -e "s%^RM.*$%#%" \
      -e "s%^BASENAME.*%\BASENAME=$out%" \
      -e "s%^LIBS=.*%LIBS=-lm%"
    sed -e "s%getline%thisgetline%g" -i src/*.c src/*.h
    sed -e "3i\
    .PHONY: install
    " -i Makefile
  '';

  meta = with lib; {
    description = "Mail processing and filtering utility";
    homepage = "http://www.procmail.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
