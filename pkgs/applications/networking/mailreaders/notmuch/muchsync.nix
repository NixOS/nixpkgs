{ lib, stdenv, fetchurl
, notmuch, openssl, pkg-config, sqlite, xapian, zlib
}:
stdenv.mkDerivation rec {
  version = "5";
  pname = "muchsync";
  passthru = {
    inherit version;
  };
  src = fetchurl {
    url = "http://www.muchsync.org/src/${pname}-${version}.tar.gz";
    sha256 = "1k2m44pj5i6vfhp9icdqs42chsp208llanc666p3d9nww8ngq2lb";
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
