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

stdenv.mkDerivation (finalAttrs: {
  pname = "maildrop";
  version = "3.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/courier/maildrop/${finalAttrs.version}/maildrop-${finalAttrs.version}.tar.bz2";
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

  meta = {
    homepage = "http://www.courier-mta.org/maildrop/";
    description = "Mail filter/mail delivery agent that is used by the Courier Mail Server";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
