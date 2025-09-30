{
  lib,
  stdenv,
  fetchgit,
  cmake,
}:

stdenv.mkDerivation rec {
  version = "7";
  pname = "libuecc";

  src = fetchgit {
    url = "git://git.universe-factory.net/libuecc";
    tag = "v${version}";
    sha256 = "1sm05aql75sh13ykgsv3ns4x4zzw9lvzid6misd22gfgf6r9n5fs";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Very small Elliptic Curve Cryptography library";
    homepage = "https://git.universe-factory.net/libuecc";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
