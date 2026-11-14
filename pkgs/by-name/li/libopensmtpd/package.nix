{
  lib,
  stdenv,
  fetchurl,
  libevent,
  mandoc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libopensmtpd";
  version = "0.7";

  src = fetchurl {
    url = "https://imperialat.at/releases/libopensmtpd-${finalAttrs.version}.tar.gz";
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

  meta = {
    description = "Library for creating OpenSMTPD filters";
    homepage = "http://imperialat.at/dev/libopensmtpd/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ malte-v ];
  };
})
