{ lib, stdenv, fetchurl, fetchpatch, ncurses, zlib, bzip2, sqlite, pkg-config, glib, gnutls }:

stdenv.mkDerivation rec {
  pname = "ncdc";
  version = "1.22.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdc-${version}.tar.gz";
    sha256 = "1bdgqd07f026qk6vpbxqsin536znd33931m3b4z44prlm9wd6pyi";
  };

  patches = [
    # Upstream fix for ncurses-6.3 support:
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://g.blicky.net/ncdc.git/patch/?id=4126dd51e90deb9e22dfd139cc4518a7812fcad6";
      sha256 = "13hqkmhmbazj6cllb5b2ccgf51vsn5lri7jqkqc5xwivgcisfrij";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses zlib bzip2 sqlite glib gnutls ];

  meta = with lib; {
    description = "Modern and lightweight direct connect client with a friendly ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdc";
    license = licenses.mit;
    platforms = platforms.linux; # arbitrary
    maintainers = with maintainers; [ ehmry ];
  };
}
