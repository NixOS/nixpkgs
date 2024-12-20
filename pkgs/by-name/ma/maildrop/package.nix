{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  pcre,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "maildrop";
  version = "2.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/courier/maildrop/${version}/maildrop-${version}.tar.bz2";
    sha256 = "1a94p2b41iy334cwfwmzi19557dn5j61abh0cp2rfc9dkc8ibhdg";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pcre
    perl
  ];

  patches = [ ./maildrop.configure.hack.patch ]; # for building in chroot

  doCheck = false; # fails with "setlocale: LC_ALL: cannot change locale (en_US.UTF-8)"

  meta = with lib; {
    homepage = "http://www.courier-mta.org/maildrop/";
    description = "Mail filter/mail delivery agent that is used by the Courier Mail Server";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
