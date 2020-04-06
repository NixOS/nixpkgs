{ stdenv, fetchurl
, notmuch, openssl, pkgconfig, sqlite, xapian, zlib
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
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ notmuch openssl sqlite xapian zlib ];
  meta = {
    description = "Synchronize maildirs and notmuch databases";
    homepage = "http://www.muchsync.org/";
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ocharles ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
