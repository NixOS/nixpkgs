{ lib
, fetchzip
, libxcrypt
, linux-pam
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "passwdqc";
  version = "2.0.3";

  src = fetchzip {
    url = "https://www.openwall.com/passwdqc/passwdqc-${version}.tar.gz";
    hash = "sha256-EgPeccqS+DDDMBVMc4bd70EMnXFuyglftxuqoaYHwNY=";
  };

  buildInputs = [
    linux-pam
    libxcrypt
  ];

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "DEVEL_LIBDIR=${placeholder "out"}/lib"
    "SHARED_LIBDIR=${placeholder "out"}/lib"
    "SECUREDIR=${placeholder "out"}/lib/secure"
    "INCLUDEDIR=${placeholder "out"}/include"
    "MANDIR=${placeholder "out"}/share/man"
    "LOCALEDIR=${placeholder "out"}/share/locale"
    "CONFDIR=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "Password/passphrase strength checking and enforcement";
    homepage = "https://www.openwall.com/passwdqc/";
    platforms = platforms.linux;
    license = licenses.bsd0;
    maintainers = [ maintainers.simsor ];
  };
}
