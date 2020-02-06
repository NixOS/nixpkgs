{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  pname = "getxbook";
  version = "1.2";

  src = fetchurl {
    url    = "https://njw.me.uk/getxbook/${pname}-${version}.tar.xz";
    sha256 = "0ihwrx4gspj8l7fc8vxch6dpjrw1lvv9z3c19f0wxnmnxhv1cjvs";
  };

  NIX_CFLAGS_COMPILE = builtins.toString [
    "-Wno-error=format-truncation"
    "-Wno-error=deprecated-declarations"
    "-Wno-error=stringop-overflow"
  ];

  buildInputs = [ openssl ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A collection of tools to download books from Google Books";
    homepage    = https://njw.me.uk/getxbook/;
    license     = licenses.isc;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.all;
    inherit version;
  };
}
