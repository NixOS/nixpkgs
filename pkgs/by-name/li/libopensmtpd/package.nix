{
  lib,
  stdenv,
  fetchurl,
  libevent,
  mandoc,
}:
stdenv.mkDerivation rec {
  pname = "libopensmtpd";
  version = "0.7";

  src = fetchurl {
    url = "https://imperialat.at/releases/libopensmtpd-${version}.tar.gz";
    hash = "sha256-zdbV4RpwY/kmXaQ6QjCcZGVUuLaLA5gsqEctvisIphM=";
  };

  patches = [ ./no-chown-while-installing.patch ];

  buildInputs = [ libevent ];

  nativeBuildInputs = [ mandoc ];

  makeFlags = [
    "-f Makefile.gnu"
    "DESTDIR=$(out)"
    "LOCALBASE="
  ];

<<<<<<< HEAD
  meta = {
    description = "Library for creating OpenSMTPD filters";
    homepage = "http://imperialat.at/dev/libopensmtpd/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ malte-v ];
=======
  meta = with lib; {
    description = "Library for creating OpenSMTPD filters";
    homepage = "http://imperialat.at/dev/libopensmtpd/";
    license = licenses.isc;
    maintainers = with maintainers; [ malte-v ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
