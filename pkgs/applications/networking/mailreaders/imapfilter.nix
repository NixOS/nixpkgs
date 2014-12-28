{ stdenv, fetchurl, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  name = "imapfilter-2.5.7";

  src = fetchurl {
    url = "https://github.com/lefcha/imapfilter/archive/v2.5.7.tar.gz";
    sha256 = "1l7sg7pyw1i8cxqnyb5xv983fakj8mxq6w44qd7w3kc7l6ixd4n7";
  };

  makeFlagsArray = "PREFIX=$(out)";
  propagatedBuildInputs = [ openssl pcre lua ];

  meta = {
    homepage = "https://github.com/lefcha/imapfilter";
    description = "Mail filtering utility";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
