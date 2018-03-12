{ stdenv, fetchFromGitHub, libiconv }:

stdenv.mkDerivation rec {
  name = "mblaze-${version}";
  version = "0.3.2";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "0sgzcf7lpgdix7x4p6wp1jjv9h62rrkca6325c7a9j8r0dbg1fdg";
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
