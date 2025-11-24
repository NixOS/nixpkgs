{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  courier-unicode,
  pcre2,
  libidn2,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "maildrop";
  version = "3.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/courier/maildrop/${version}/maildrop-${version}.tar.bz2";
    hash = "sha256-PFiQ9NQzItTmPz6Aw6YJzeYF9ylm1iNPyIZBjZSdJLk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    courier-unicode
    libidn2
    pcre2
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
