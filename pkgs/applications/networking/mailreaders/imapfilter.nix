{ stdenv, fetchurl, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  name = "imapfilter-2.5.4";
  
  src = fetchurl {
    url = "https://github.com/lefcha/imapfilter/archive/v2.5.4.tar.gz";
    sha256 = "e5a9ee0e57e16d02ff2cbb37b67202a514121d2eb7fc63863174644ca8248769";
  };

  makeFlagsArray = "PREFIX=$(out)";
  
  propagatedBuildInputs = [ openssl pcre lua ];
}

