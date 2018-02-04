{ stdenv, fetchFromGitHub, libiconv }:

stdenv.mkDerivation rec {
  name = "mblaze-${version}";
  version = "0.3";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "1jrn81rvw6qanlfppc12dkvpbmidzrq1lx3rfhvcsna55k3gjyw9";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/mblaze;
    description = "Unix utilities to deal with Maildir";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = [ maintainers.ajgrf ];
  };
}
