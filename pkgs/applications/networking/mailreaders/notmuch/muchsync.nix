{ lib, stdenv, fetchurl
, notmuch, openssl, pkg-config, sqlite, xapian, zlib
}:
stdenv.mkDerivation rec {
  version = "7";
  pname = "muchsync";
  passthru = {
    inherit version;
  };
  src = fetchurl {
    url = "http://www.muchsync.org/src/${pname}-${version}.tar.gz";
    hash = "sha256-+D4vb80O9IE0df3cjTkoVoZlTaX0FWWh6ams14Gjvqw=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ notmuch openssl sqlite xapian zlib ];
  XAPIAN_CONFIG = "${xapian}/bin/xapian-config";
  meta = {
    description = "Synchronize maildirs and notmuch databases";
    homepage = "http://www.muchsync.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [];
    license = lib.licenses.gpl2Plus;
  };
}
