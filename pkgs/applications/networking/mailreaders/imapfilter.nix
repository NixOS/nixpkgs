{ stdenv, fetchFromGitHub, openssl, lua, pcre }:

stdenv.mkDerivation rec {
  pname = "imapfilter";
  version = "2.6.13";

  src = fetchFromGitHub {
    owner = "lefcha";
    repo = "imapfilter";
    rev = "v${version}";
    sha256 = "02997rnnvid3rfkxmlgjpbspi4svdmq8r8wd2zvf25iadim3hxqi";
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
