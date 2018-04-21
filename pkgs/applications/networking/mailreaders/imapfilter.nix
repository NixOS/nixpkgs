{ stdenv, fetchFromGitHub, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  name = "imapfilter-${version}";
  version = "2.6.11";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${version}";
    sha256 = "0cjnp7vqmgqym2zswabkmwlbj21r063vw7wkwxglj08z5qyjl5ps";
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
