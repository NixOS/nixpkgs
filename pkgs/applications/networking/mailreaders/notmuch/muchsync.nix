{ lib, stdenv, fetchurl
, notmuch, openssl, pkg-config, sqlite, xapian, zlib
}:
stdenv.mkDerivation rec {
  version = "6";
  pname = "muchsync";
  passthru = {
    inherit version;
  };
  src = fetchurl {
    url = "http://www.muchsync.org/src/${pname}-${version}.tar.gz";
    sha256 = "Cz3jtNiF7bn4h6B9y8i1luf+8gOMYeaCz6VaE/pM6eg=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ notmuch openssl sqlite xapian zlib ];
  meta = {
    description = "Synchronize maildirs and notmuch databases";
    homepage = "http://www.muchsync.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [];
    license = lib.licenses.gpl2Plus;
  };
}
