{ stdenv, fetchFromGitHub, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  name = "imapfilter-${version}";
  version = "2.6.12";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${version}";
    sha256 = "0vzpc54fjf5vb5vx5w0fl20xvx1k9cg6a3hbl86mm8kwsqf3wrab";
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
