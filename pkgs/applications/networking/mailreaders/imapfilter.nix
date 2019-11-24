{ stdenv, fetchFromGitHub, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  pname = "imapfilter";
  version = "2.6.14";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${version}";
    sha256 = "09aq9gw1vz0zl6k4fb4zdm6cpjhddsl13asfjx3qy21pbw0azmj6";
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
