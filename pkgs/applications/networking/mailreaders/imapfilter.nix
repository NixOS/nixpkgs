{ stdenv, fetchurl, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  name = "imapfilter-2.6.3";

  src = fetchurl {
    url = "https://github.com/lefcha/imapfilter/archive/v2.6.3.tar.gz";
    sha256 = "0i6j9ilzh43b9gyqs3y3rv0d9yvbbg12gcbqbar9i92wdlnqcx0i";
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
