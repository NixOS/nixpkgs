{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "getxbook-${version}";
  version = "1.2";

  src = fetchurl {
    url    = "https://njw.me.uk/getxbook/${name}.tar.xz";
    sha256 = "0ihwrx4gspj8l7fc8vxch6dpjrw1lvv9z3c19f0wxnmnxhv1cjvs";
  };

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
