{ stdenv, fetchFromGitHub, libiconv }:

stdenv.mkDerivation rec {
  name = "mblaze-${version}";
  version = "0.4";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "15ac213a17mxni3bqvzxhiln65s4almrlmv72bbcgi7cymb303rp";
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
