{ stdenv, fetchFromGitHub, libiconv }:

stdenv.mkDerivation rec {
  name = "mblaze-${version}";
  version = "0.5.1";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  src = fetchFromGitHub {
    owner = "chneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "11x548dl2jy9cmgsakqrzfdq166whhk4ja7zkiaxrapkjmkf6pbh";
  };

  makeFlags = "PREFIX=$(out)";

  postInstall = ''
    install -Dm644 -t $out/share/zsh/site-functions contrib/_mblaze
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/chneukirchen/mblaze;
    description = "Unix utilities to deal with Maildir";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = [ maintainers.ajgrf ];
  };
}
