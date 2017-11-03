{ stdenv, fetchFromGitHub, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  name = "imapfilter-${version}";
  version = "2.6.10";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${version}";
    sha256 = "1011pbgbaz43kmxcc5alv06jly9wqmqgr0b64cm5i1md727v3rzc";
  };

  makeFlagsArray = "PREFIX=$(out)";
  propagatedBuildInputs = [ openssl pcre lua ];

  meta = {
    homepage = https://github.com/lefcha/imapfilter;
    description = "Mail filtering utility";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
