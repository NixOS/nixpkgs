{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "1.6.02";
  pname = "hdate";
  src = fetchurl {
    url = "https://sourceforge.net/projects/libhdate/files/libhdate/libhdate-${version}/libhdate-${version}.tar.bz2";
    sha256 = "3c930a8deb57c01896dc37f0d7804e5a330ee8e88c4ff610b71f9d2b02c17762";
  };
  meta = with lib; {
    description = "Hebrew calendar and solar astronomical times library and utilities";
    homepage = "https://sourceforge.net/projects/libhdate/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ CharlesHD ];
  };
}
