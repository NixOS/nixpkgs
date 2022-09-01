{ lib, stdenv, fetchurl, fetchFromGitHub, msmtp }:

stdenv.mkDerivation rec {
  pname = "procmail";
  version = "3.24";

  src = fetchFromGitHub {
    owner = "BuGlessRB";
    repo = "procmail";
    rev = "v${version}";
    sha256 = "sha256-z0g+IeSldUSwv/W4pAQhtWiughujxsEPgDcsW9Fx3jY=";
  };

  patches = [ ./autoconf-bin-lookup-path.patch ];

  # procmail forwarding action relies on a package providing sendmail
  buildInputs = [ msmtp ];

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
    homepage = "https://github.com/BuGlessRB/procmail";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
