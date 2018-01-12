{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mblaze-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "0p97zfl35ilrnrx9ynj82igsb698m9klikfaicw5jhjpf6qp2n3y";
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
