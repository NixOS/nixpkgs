{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
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

  patches = [
    # Backport CMake 4 support
    (fetchpatch {
      url = "https://github.com/neocturne/libuecc/commit/b3812bf5ab1777193c4b85863311c33997d141f9.patch";
      hash = "sha256-3h+LC5JlSXNiJlEQxSQzC7+5s+nMp+ll2NQQC5HzTf0=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Very small Elliptic Curve Cryptography library";
    homepage = "https://git.universe-factory.net/libuecc";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
