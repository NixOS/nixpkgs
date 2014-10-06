{ stdenv, fetchurl, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  name = "imapfilter-2.5.6";

  src = fetchurl {
    url = "https://github.com/lefcha/imapfilter/archive/v2.5.6.tar.gz";
    sha256 = "0c94xdcnkk33d2filzkbraymfzm09np78486kqzqwidnnfllsk86";
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
